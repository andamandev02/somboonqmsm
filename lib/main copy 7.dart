// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:somboonqms/domain.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await _requestPermissions();
//   await Hive.initFlutter();
//   await Hive.openBox('DomainUrl');
//   runApp(const MyApp());
// }

// Future<void> _requestPermissions() async {
//   final statuses = await [
//     Permission.bluetooth,
//     Permission.bluetoothConnect,
//     Permission.bluetoothScan,
//   ].request();

//   if (statuses[Permission.bluetooth]!.isGranted &&
//       statuses[Permission.bluetoothConnect]!.isGranted &&
//       statuses[Permission.bluetoothScan]!.isGranted) {
//     print('All permissions granted');
//   } else {
//     print('Some permissions are not granted');
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme:
//             ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
//         useMaterial3: true,
//       ),
//       home: const ApplicationDomainScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Print Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final pdf = pw.Document();
              pdf.addPage(
                pw.Page(
                  build: (pw.Context context) => pw.Center(
                    child: pw.Text('Hello World!'),
                  ),
                ),
              );
              await Printing.layoutPdf(
                onLayout: (PdfPageFormat format) async => pdf.save(),
              );
            },
            child: Text('Print PDF'),
          ),
        ),
      ),
    );
  }
}
