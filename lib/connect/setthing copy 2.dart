// import 'dart:ui';

// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;

// import 'package:hive/hive.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class SettingScreen extends StatefulWidget {
//   const SettingScreen({super.key});

//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
//   List<BluetoothDiscoveryResult> _devicesList = [];
//   List<BluetoothDevice> _pairedDevices = [];
//   BluetoothDevice? _selectedDevice;
//   bool _isDiscovering = false;

//   @override
//   void initState() {
//     super.initState();
//     loadDataFromHive();
//     _getPairedDevices();
//     _startDiscovery();
//   }

//   Future<void> loadDataFromHive() async {
//     var PrinterBox = await Hive.openBox('PrinterDevice');
//     String? printerAddress = PrinterBox.get('PrinterDevice');
//     BluetoothDevice? foundDevice;
//     if (printerAddress != null) {
//       foundDevice = _pairedDevices.firstWhere(
//         (device) => device.address == printerAddress,
//       );
//       if (foundDevice == null) {
//         foundDevice = _devicesList.map((result) => result.device).firstWhere(
//               (device) => device.address == printerAddress,
//             );
//       }
//       if (foundDevice != null) {
//         setState(() {
//           _selectedDevice = foundDevice;
//         });
//       }
//     }

//     await PrinterBox.close();
//   }

//   void _getPairedDevices() async {
//     final pairedDevices = await _bluetooth.getBondedDevices();
//     setState(() {
//       _pairedDevices = pairedDevices;
//     });
//   }

//   void _startDiscovery() async {
//     if (_isDiscovering) return;
//     setState(() {
//       _isDiscovering = true;
//       _devicesList.clear();
//     });

//     _bluetooth.startDiscovery().listen((device) {
//       setState(() {
//         _devicesList.add(device);
//       });
//     }).onDone(() {
//       setState(() {
//         _isDiscovering = false;
//       });
//     });
//   }

//   void _showPrintPreview(BuildContext context) async {
//     final Uint8List logoBytes = await rootBundle
//         .load('assets/icon/icon.png')
//         .then((data) => data.buffer.asUint8List());

//     final Uint8List qrBytes =
//         await createQrImage('https://somboonqms.andamandev.com', 200.0);
//     final img.Image qrImage = img.decodeImage(qrBytes)!;
//     final img.Image lgImage = img.decodeImage(logoBytes)!;
//     _printMessage(_selectedDevice!, lgImage, qrImage);
//   }

//   Future<Uint8List> createQrImage(String data, double size) async {
//     final qrValidationResult = QrValidator.validate(
//       data: data,
//       version: QrVersions.auto,
//       errorCorrectionLevel: QrErrorCorrectLevel.L,
//     );

//     if (qrValidationResult.status == QrValidationStatus.valid) {
//       final qrCode = qrValidationResult.qrCode;
//       final painter = QrPainter.withQr(
//         qr: qrCode!,
//         color: const Color(0xFF000000),
//         emptyColor: const Color(0xFFFFFFFF),
//         gapless: true,
//       );

//       final picData = await painter.toImageData(size);
//       return picData!.buffer.asUint8List();
//     } else {
//       throw Exception('QR code generation failed');
//     }
//   }

//   void _printMessage(
//       BluetoothDevice device, img.Image lgImage, img.Image qrImage) async {
//     try {
//       BluetoothConnection connection =
//           await BluetoothConnection.toAddress(device.address);

//       final profile = await CapabilityProfile.load();
//       final printer = Generator(PaperSize.mm80, profile);

//       final List<int> bytes = [];

//       // ปรับขนาดของรูปภาพ
//       bytes.addAll(printer.image(img.copyResize(lgImage, width: 80)));

//       // ปรับขนาดอักษร
//       bytes.addAll(printer.text(
//         'Hello SomboonPhotchana',
//         styles: PosStyles(
//           align: PosAlign.left,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//       ));

//       bytes.addAll(printer.text(
//         'Hello Ratchada',
//         styles: PosStyles(
//           align: PosAlign.left,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//       ));

//       // ปรับขนาดของ QR code
//       bytes.addAll(printer.image(img.copyResize(qrImage, width: 80)));

//       bytes.addAll(printer.cut());
//       connection.output.add(Uint8List.fromList(bytes));
//       await connection.output.allSent;
//       await connection.finish();
//       print('Disconnected from the device');
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
//         title: const Text(
//           'ตั้งค่าเครื่องพิมพ์',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             if (_isDiscovering)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CircularProgressIndicator(),
//               ),
//             DropdownButton<BluetoothDevice>(
//               hint: const Text(
//                 'เลือกอุปกรณ์',
//                 style: TextStyle(color: Colors.white),
//               ),
//               value: _selectedDevice,
//               onChanged: (BluetoothDevice? newValue) {
//                 setState(() {
//                   _selectedDevice = newValue;
//                 });
//               },
//               items: [
//                 ..._pairedDevices.map<DropdownMenuItem<BluetoothDevice>>(
//                     (BluetoothDevice device) {
//                   return DropdownMenuItem<BluetoothDevice>(
//                     value: device,
//                     child: Text(
//                       device.name ?? 'Unnamed Device',
//                       style: const TextStyle(color: Colors.black),
//                     ),
//                   );
//                 }).toList(),
//                 ..._devicesList.map<DropdownMenuItem<BluetoothDevice>>(
//                     (BluetoothDiscoveryResult result) {
//                   final device = result.device;
//                   return DropdownMenuItem<BluetoothDevice>(
//                     value: device,
//                     child: Text(
//                       device.name ?? 'Unnamed Device',
//                       style: const TextStyle(color: Colors.black),
//                     ),
//                   );
//                 }).toList(),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             Spacer(), // Spacer จะผลักดันปุ่มลงไปด้านล่าง
//             ElevatedButton(
//               onPressed: () async {
//                 if (_selectedDevice != null) {
//                   var PrinterBox = await Hive.openBox('PrinterDevice');
//                   await PrinterBox.put(
//                       'PrinterDevice', _selectedDevice!.address);
//                   await PrinterBox.close();
//                   await loadDataFromHive();
//                   // _printMessage(_selectedDevice!);
//                   _showPrintPreview(context);
//                 }
//               },
//               child: const Text('ทดลองพิมพ์'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: const Color.fromRGBO(255, 193, 7, 1.0),
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 textStyle: const TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DeviceDetailsScreen extends StatelessWidget {
//   final BluetoothDevice device;

//   DeviceDetailsScreen({required this.device});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(device.name ?? 'Unknown Device'),
//       ),
//       body: Center(
//         child: Text('Details for ${device.name ?? 'Unknown Device'}'),
//       ),
//     );
//   }
// }
