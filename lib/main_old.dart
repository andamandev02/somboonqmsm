import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:somboonqms/domain.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions();
  await Hive.initFlutter();
  await Hive.openBox('DomainUrl');
  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  final statuses = await [
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.bluetoothScan,
  ].request();

  if (statuses[Permission.bluetooth]!.isGranted &&
      statuses[Permission.bluetoothConnect]!.isGranted &&
      statuses[Permission.bluetoothScan]!.isGranted) {
    print('All permissions granted');
  } else {
    print('Some permissions are not granted');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const ApplicationDomainScreen(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:flutter/services.dart'
//     show ByteData, PlatformException, Uint8List, rootBundle;
// import 'package:flutter/material.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:flutter/services.dart' show rootBundle;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: PrintScreen(),
//     );
//   }
// }

// class PrintScreen extends StatefulWidget {
//   @override
//   _PrintScreenState createState() => _PrintScreenState();
// }

// class _PrintScreenState extends State<PrintScreen> {
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
//   List<BluetoothDevice> _devices = [];
//   BluetoothDevice? _selectedDevice;

//   @override
//   void initState() {
//     super.initState();
//     _getPairedDevices();
//   }

//   Future<void> _getPairedDevices() async {
//     List<BluetoothDevice> devices = [];
//     try {
//       devices = await bluetooth.getBondedDevices();
//     } on PlatformException {
//       // Handle error
//     }

//     if (!mounted) return;

//     setState(() {
//       _devices = devices;
//     });
//   }
//   Future<Uint8List> _loadImage(String path) async {
//     final ByteData data = await rootBundle.load(path);
//     return data.buffer.asUint8List();
//   }

//   void _printContent() async {
//     if (_selectedDevice != null) {
//       await bluetooth.connect(_selectedDevice!);

//       // ปริ้นข้อความ
//       bluetooth.printCustom("Hello, this is a test print.", 1, 1);
//       bluetooth.printCustom("Here is an image:", 1, 1);

//       // เพิ่มบรรทัดว่างเพื่อแยกแถว
//       bluetooth.printCustom("", 1, 1);

//       // โหลดรูปภาพจาก assets
//       Uint8List imageBytes = await _loadImage('assets/logo/images.jpg');

//       // ปริ้นข้อความและรูปภาพในแถวเดียวกัน
//       bluetooth.printCustom("Image:", 1, 1);  // ข้อความที่จะพิมพ์ก่อนรูปภาพ
//       await bluetooth.printImageBytes(imageBytes, 0, 150); // รูปภาพ
//       bluetooth.printCustom("", 1, 1); // เพิ่มบรรทัดว่างเพื่อเริ่มแถวใหม่หลังจากพิมพ์รูปภาพ

//       await bluetooth.disconnect();
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Devices'),
//       ),
//       body: Column(
//         children: <Widget>[
//           DropdownButton<BluetoothDevice>(
//             items: _devices
//                 .map((device) => DropdownMenuItem(
//                       child: Text(device.name!),
//                       value: device,
//                     ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedDevice = value;
//               });
//             },
//             value: _selectedDevice,
//           ),
//           ElevatedButton(
//             onPressed: _printContent,
//             child: Text('Print Content'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:nyx_printer/nyx_printer.dart';
// import 'dart:async';
// import 'package:flutter/services.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   BlueThermalPrinter _blueThermalPrinter = BlueThermalPrinter.instance;
//   List<BluetoothDevice> _devices = [];
//   BluetoothDevice? _selectedDevice;
//   final NyxPrinter _nyxPrinter = NyxPrinter();

//   @override
//   void initState() {
//     super.initState();
//     _loadConnectedDevices();
//   }

//   Future<void> _loadConnectedDevices() async {
//     try {
//       final devices = await _blueThermalPrinter.getBondedDevices();
//       setState(() {
//         _devices = devices;
//         if (_devices.isNotEmpty) {
//           _selectedDevice = _devices.first;
//         }
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _selectDevice(BluetoothDevice? device) async {
//     setState(() {
//       _selectedDevice = device;
//     });
//   }

//   Future<void> _printImage() async {
//     if (_selectedDevice == null) return;
//     try {
//       final image = await rootBundle.load("assets/logo/images.jpg");
//       await _nyxPrinter.printImage(image.buffer.asUint8List());
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _printText(String text, {NyxTextFormat? format}) async {
//     if (_selectedDevice == null) return;
//     try {
//       await _nyxPrinter.printText(text, textFormat: format);
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _printBarcode() async {
//     if (_selectedDevice == null) return;
//     try {
//       await _nyxPrinter.printBarcode("123456789", width: 300, height: 40);
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _printQr() async {
//     if (_selectedDevice == null) return;
//     try {
//       await _nyxPrinter.printQrCode("123456789", width: 200, height: 200);
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _printReceipt() async {
//     if (_selectedDevice == null) return;
//     try {
//       await _nyxPrinter.printText("Grocery Store",
//           textFormat: NyxTextFormat(
//             textSize: 32,
//             align: NyxAlign.center,
//             font: NyxFont.monospace,
//             style: NyxFontStyle.boldItalic,
//           ));
//       await _nyxPrinter.printText("Invoice: 000001");
//       await _nyxPrinter.printText("Seller: Mike");
//       await _nyxPrinter.printText("Neme\t\t\t\t\t\t\t\t\t\t\t\tPrice");
//       await _nyxPrinter.printText(
//         "Cucumber\t\t\t\t\t\t\t\t\t\t10\$",
//         textFormat: NyxTextFormat(topPadding: 5),
//       );
//       await _nyxPrinter.printText("Potato Fresh\t\t\t\t\t\t\t\t\t15\$");
//       await _nyxPrinter.printText("Tomato\t\t\t\t\t\t\t\t\t\t\t 9\$");
//       await _nyxPrinter.printText(
//         "Tax\t\t\t\t\t\t\t\t\t\t\t\t\t  4\$",
//         textFormat: NyxTextFormat(
//           topPadding: 5,
//           style: NyxFontStyle.bold,
//           textSize: 26,
//         ),
//       );
//       await _nyxPrinter.printText(
//         "Total\t\t\t\t\t\t\t\t\t\t\t\t34\$",
//         textFormat: NyxTextFormat(
//           topPadding: 5,
//           style: NyxFontStyle.bold,
//           textSize: 26,
//         ),
//       );
//       await _nyxPrinter.printQrCode("123456789", width: 200, height: 200);
//       await _nyxPrinter.printText("");
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Bluetooth Printer App'),
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: <Widget>[
//                 DropdownButton<BluetoothDevice>(
//                   items: _devices
//                       .map((device) => DropdownMenuItem(
//                             child: Text(device.name!),
//                             value: device,
//                           ))
//                       .toList(),
//                   onChanged: _selectDevice,
//                   value: _selectedDevice,
//                 ),
//                 SizedBox(
//                   width: size.width,
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed: _printImage,
//                     child: const Text('Print Image'),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: SizedBox(
//                             height: 48,
//                             child: ElevatedButton(
//                               onPressed: () => _printText("Welcome to Nyx"),
//                               child: const Text('Text Left'),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: SizedBox(
//                             height: 48,
//                             child: ElevatedButton(
//                               onPressed: () => _printText(
//                                 "Welcome to Nyx",
//                                 format: NyxTextFormat(align: NyxAlign.center),
//                               ),
//                               child: const Text('Text Center'),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: SizedBox(
//                             height: 48,
//                             child: ElevatedButton(
//                               onPressed: () => _printText(
//                                 "Welcome to Nyx",
//                                 format: NyxTextFormat(align: NyxAlign.right),
//                               ),
//                               child: const Text('Text Right'),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: SizedBox(
//                     width: size.width,
//                     height: 48,
//                     child: ElevatedButton(
//                       onPressed: _printBarcode,
//                       child: const Text('Print Barcode'),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: SizedBox(
//                     width: size.width,
//                     height: 48,
//                     child: ElevatedButton(
//                       onPressed: _printQr,
//                       child: const Text('Print QR'),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: SizedBox(
//                     width: size.width,
//                     height: 48,
//                     child: ElevatedButton(
//                       onPressed: _printReceipt,
//                       child: const Text('Print Receipt'),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
