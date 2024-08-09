import 'package:hive/hive.dart';
import 'package:somboonqms/testprint.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:nyx_printer/nyx_printer.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();

  static void sample(BuildContext context, Map<String, dynamic> qrData) {}
}

class _SettingScreenState extends State<SettingScreen> {
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

//   List<BluetoothDevice> _devices = [];
//   BluetoothDevice? _device;
//   bool _connected = false;
//   TestPrint testPrint = TestPrint();

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   Future<void> initPlatformState() async {
//     bool? isConnected = await bluetooth.isConnected;
//     List<BluetoothDevice> devices = [];
//     try {
//       devices = await bluetooth.getBondedDevices();
//     } on PlatformException {}

//     bluetooth.onStateChanged().listen((state) {
//       switch (state) {
//         case BlueThermalPrinter.CONNECTED:
//           setState(() {
//             _connected = true;
//             print("bluetooth device state: connected");
//           });
//           break;
//         case BlueThermalPrinter.DISCONNECTED:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: disconnected");
//           });
//           break;
//         case BlueThermalPrinter.DISCONNECT_REQUESTED:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: disconnect requested");
//           });
//           break;
//         case BlueThermalPrinter.STATE_TURNING_OFF:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: bluetooth turning off");
//           });
//           break;
//         case BlueThermalPrinter.STATE_OFF:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: bluetooth off");
//           });
//           break;
//         case BlueThermalPrinter.STATE_ON:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: bluetooth on");
//           });
//           break;
//         case BlueThermalPrinter.STATE_TURNING_ON:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: bluetooth turning on");
//           });
//           break;
//         case BlueThermalPrinter.ERROR:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: error");
//           });
//           break;
//         default:
//           print(state);
//           break;
//       }
//     });

//     if (!mounted) return;
//     setState(() {
//       _devices = devices;
//     });

//     if (isConnected == true) {
//       setState(() {
//         _connected = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Blue Thermal Printer'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListView(
//             children: <Widget>[
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   const SizedBox(width: 10),
//                   const Text(
//                     'Device:',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 30),
//                   Expanded(
//                     child: DropdownButton(
//                       items: _getDeviceItems(),
//                       onChanged: (BluetoothDevice? value) =>
//                           setState(() => _device = value),
//                       value: _device,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   ElevatedButton(
//                     style:
//                         ElevatedButton.styleFrom(backgroundColor: Colors.brown),
//                     onPressed: () {
//                       initPlatformState();
//                     },
//                     child: const Text(
//                       'Refresh',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             _connected ? Colors.red : Colors.green),
//                     onPressed: _connected ? _disconnect : _connect,
//                     child: Text(
//                       _connected ? 'Disconnect' : 'Connect',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
//                 child: ElevatedButton(
//                   style:
//                       ElevatedButton.styleFrom(backgroundColor: Colors.brown),
//                   onPressed: () {
//                     testPrint.sample();
//                   },
//                   child: const Text('PRINT TEST',
//                       style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
//     List<DropdownMenuItem<BluetoothDevice>> items = [];
//     if (_devices.isEmpty) {
//       items.add(DropdownMenuItem(
//         child: Text('NONE'),
//       ));
//     } else {
//       _devices.forEach((device) {
//         items.add(DropdownMenuItem(
//           child: Text(device.name ?? ""),
//           value: device,
//         ));
//       });
//     }
//     return items;
//   }

//   void _connect() {
//     if (_device != null) {
//       bluetooth.isConnected.then((isConnected) async {
//         if (isConnected == false) {
//           bluetooth.connect(_device!).catchError((error) {
//             setState(() => _connected = false);
//           });
//           var PrinterBox = await Hive.openBox('PrinterDevice');
//           await PrinterBox.put('PrinterDevice', _device!.address);
//           await PrinterBox.close();
//           setState(() => _connected = true);
//         }
//       });
//     } else {
//       show('No device selected.');
//     }
//   }

//   void _disconnect() {
//     bluetooth.disconnect();
//     setState(() => _connected = false);
//   }

//   Future show(
//     String message, {
//     Duration duration = const Duration(seconds: 3),
//   }) async {
//     await new Future.delayed(new Duration(milliseconds: 100));
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: const TextStyle(color: Colors.white),
//         ),
//         duration: duration,
//       ),
//     );
//   }
// }

  BlueThermalPrinter _blueThermalPrinter = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  final NyxPrinter _nyxPrinter = NyxPrinter();

  @override
  void initState() {
    super.initState();
    _loadConnectedDevices();
    loadDataFromHive();
  }

  Future<void> loadDataFromHive() async {
    var PrinterBox = await Hive.openBox('PrinterDevice');
    String? printerAddress = PrinterBox.get('PrinterDevice');
    BluetoothDevice? foundDevice;
    if (printerAddress != null) {
      foundDevice = _devices.firstWhere(
        (device) => device.address == printerAddress,
      );
      if (foundDevice != null) {
        setState(() {
          _selectedDevice = foundDevice;
        });
      }
    }
    await PrinterBox.close();
  }

  Future<void> _loadConnectedDevices() async {
    try {
      final devices = await _blueThermalPrinter.getBondedDevices();
      setState(() {
        _devices = devices;
        if (_devices.isNotEmpty) {
          _selectedDevice = _devices.first;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _selectDevice(BluetoothDevice? device) async {
    setState(() async {
      _selectedDevice = device;
      var PrinterBox = await Hive.openBox('PrinterDevice');
      await PrinterBox.put('PrinterDevice', _selectedDevice!.address);
      await PrinterBox.close();
      await loadDataFromHive();
    });
  }

  Future<void> _printImage() async {
    if (_selectedDevice == null) return;
    try {
      final image = await rootBundle.load("assets/logo/images.jpg");
      await _nyxPrinter.printImage(image.buffer.asUint8List());
    } catch (e) {
      print(e);
    }
  }

  Future<void> _printText(String text, {NyxTextFormat? format}) async {
    if (_selectedDevice == null) return;
    try {
      await _nyxPrinter.printText(text, textFormat: format);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _printBarcode() async {
    if (_selectedDevice == null) return;
    try {
      await _nyxPrinter.printBarcode("123456789", width: 300, height: 40);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _printQr() async {
    if (_selectedDevice == null) return;
    try {
      await _nyxPrinter.printQrCode("123456789", width: 200, height: 200);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _printReceipt() async {
    if (_selectedDevice == null) return;
    try {
      await _nyxPrinter.printText("Grocery Store",
          textFormat: NyxTextFormat(
            textSize: 32,
            align: NyxAlign.center,
            font: NyxFont.monospace,
            style: NyxFontStyle.boldItalic,
          ));
      await _nyxPrinter.printText("Invoice: 000001");
      await _nyxPrinter.printText("Seller: Mike");
      await _nyxPrinter.printText("Neme\t\t\t\t\t\t\t\t\t\t\t\tPrice");
      await _nyxPrinter.printText(
        "Cucumber\t\t\t\t\t\t\t\t\t\t10\$",
        textFormat: NyxTextFormat(topPadding: 5),
      );
      await _nyxPrinter.printText("Potato Fresh\t\t\t\t\t\t\t\t\t15\$");
      await _nyxPrinter.printText("Tomato\t\t\t\t\t\t\t\t\t\t\t 9\$");
      await _nyxPrinter.printText(
        "Tax\t\t\t\t\t\t\t\t\t\t\t\t\t  4\$",
        textFormat: NyxTextFormat(
          topPadding: 5,
          style: NyxFontStyle.bold,
          textSize: 26,
        ),
      );
      await _nyxPrinter.printText(
        "Total\t\t\t\t\t\t\t\t\t\t\t\t34\$",
        textFormat: NyxTextFormat(
          topPadding: 5,
          style: NyxFontStyle.bold,
          textSize: 26,
        ),
      );
      await _nyxPrinter.printQrCode("123456789", width: 200, height: 200);
      await _nyxPrinter.printText("");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Printer App'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                DropdownButton<BluetoothDevice>(
                  items: _devices
                      .map((device) => DropdownMenuItem(
                            child: Text(device.name!),
                            value: device,
                          ))
                      .toList(),
                  onChanged: _selectDevice,
                  value: _selectedDevice,
                ),
                SizedBox(
                  width: size.width,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _printImage,
                    child: const Text('Print Image'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () => _printText("Welcome to Nyx"),
                              child: const Text('Text Left'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () => _printText(
                                "Welcome to Nyx",
                                format: NyxTextFormat(align: NyxAlign.center),
                              ),
                              child: const Text('Text Center'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () => _printText(
                                "Welcome to Nyx",
                                format: NyxTextFormat(align: NyxAlign.right),
                              ),
                              child: const Text('Text Right'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    width: size.width,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _printBarcode,
                      child: const Text('Print Barcode'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    width: size.width,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _printQr,
                      child: const Text('Print QR'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    width: size.width,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _printReceipt,
                      child: const Text('Print Receipt'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
