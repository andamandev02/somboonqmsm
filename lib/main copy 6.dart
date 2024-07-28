// // import 'package:flutter/material.dart';
// // import 'package:flutter/material.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:somboonqms/domain.dart';
// // import 'package:hive_flutter/hive_flutter.dart';
// //
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized(); // เพิ่มบรรทัดนี้
// //   await _requestPermissions();
// //   await Hive.initFlutter();
// //   await Hive.openBox('DomainUrl');
// //   runApp(const MyApp());
// // }
// //
// // Future<void> _requestPermissions() async {
// //   final statuses = await [
// //     Permission.bluetooth,
// //     Permission.bluetoothConnect,
// //     Permission.bluetoothScan,
// //   ].request();
// //
// //   if (statuses[Permission.bluetooth]!.isGranted &&
// //       statuses[Permission.bluetoothConnect]!.isGranted &&
// //       statuses[Permission.bluetoothScan]!.isGranted) {
// //     print('All permissions granted');
// //   } else {
// //     print('Some permissions are not granted');
// //   }
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         colorScheme:
// //             ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
// //         useMaterial3: true,
// //       ),
// //       home: const ApplicationDomainScreen(),
// //     );
// //   }
// // }
// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BluetoothDevicesScreen(),
//     );
//   }
// }

// class BluetoothDevicesScreen extends StatefulWidget {
//   @override
//   _BluetoothDevicesScreenState createState() => _BluetoothDevicesScreenState();
// }

// class _BluetoothDevicesScreenState extends State<BluetoothDevicesScreen> {
//   List<BluetoothDevice> _devices = [];
//   BluetoothDevice? _selectedDevice;
//   BluetoothConnection? _connection;
//   bool _isConnecting = false;

//   @override
//   void initState() {
//     super.initState();
//     _getBondedDevices();
//   }

//   Future<void> _getBondedDevices() async {
//     List<BluetoothDevice> devices = [];

//     try {
//       devices = await FlutterBluetoothSerial.instance.getBondedDevices();
//     } catch (e) {
//       print("Error: $e");
//     }

//     setState(() {
//       _devices = devices;
//     });
//   }

//   Future<void> _connectToDevice() async {
//     if (_selectedDevice != null) {
//       setState(() {
//         _isConnecting = true;
//       });
//       try {
//         _connection =
//             await BluetoothConnection.toAddress(_selectedDevice!.address);
//         print('Connected to the device');
//         setState(() {
//           _isConnecting = false;
//         });
//       } catch (e) {
//         print('Cannot connect, exception occurred: $e');
//         setState(() {
//           _isConnecting = false;
//         });
//       }
//     } else {
//       print('No device selected');
//     }
//   }

//   Future<void> _printTest() async {
//     if (_connection != null && _connection!.isConnected) {
//       // ส่งคำสั่งการพิมพ์ไปยังเครื่องพิมพ์
//       _connection!.output.add(Uint8List.fromList(utf8.encode("Test print\n")));
//       await _connection!.output.allSent;
//       print('Printing...');
//     } else {
//       print('Connection is not established');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Paired Bluetooth Devices'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _devices.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_devices[index].name ?? 'Unknown device'),
//                   subtitle: Text(_devices[index].address),
//                   trailing: _selectedDevice == _devices[index]
//                       ? Icon(Icons.check, color: Colors.green)
//                       : null,
//                   onTap: () {
//                     setState(() {
//                       _selectedDevice = _devices[index];
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 ElevatedButton(
//                   onPressed: _isConnecting ? null : _connectToDevice,
//                   child: _isConnecting
//                       ? CircularProgressIndicator()
//                       : Text('เชื่อมต่ออุปกรณ์'),
//                 ),
//                 if (_connection != null && _connection!.isConnected)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10.0),
//                     child: Text(
//                       'เชื่อมต่อกับ: ${_selectedDevice?.name}',
//                       style: TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _printTest,
//                   child: Text('ทดลองพิมพ์'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
