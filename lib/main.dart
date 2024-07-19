// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:somboonqms/connect/ble_controller.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("BLE SCANNER"),
//       ),
//       body: GetBuilder<BleController>(
//         init: BleController(),
//         builder: (BleController controller) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 StreamBuilder<List<ScanResult>>(
//                   stream: controller.scanResults,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return Expanded(
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: snapshot.data!.length,
//                           itemBuilder: (context, index) {
//                             final data = snapshot.data![index];
//                             return Card(
//                               elevation: 2,
//                               child: ListTile(
//                                 title: Text(data.device.name),
//                                 subtitle: Text(data.device.id.id),
//                                 trailing: Text(data.rssi.toString()),
//                                 onTap: () =>
//                                     controller.connectToDevice(data.device),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     } else {
//                       return const Center(
//                         child: Text("No Device Found"),
//                       );
//                     }
//                   },
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     controller.scanDevices();
//                   },
//                   child: const Text("SCAN"),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:somboonqms/domain.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('DomainUrl');
  runApp(const MyApp());
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
