// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:typed_data';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter PDF Print Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Print Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _showPdfDialog(context),
//           child: Text('Show PDF'),
//         ),
//       ),
//     );
//   }

//   void _showPdfDialog(BuildContext context) async {
//     final pdfData = await _createPdfWithText('Hello, this is a sample PDF.');

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('PDF Preview'),
//           content: Container(
//             height: 400,
//             width: 300,
//             child: PDFView(
//               pdfData: pdfData,
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Print'),
//               onPressed: () {
//                 _printPdf(pdfData);
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<Uint8List> _createPdfWithText(String text) async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Text(text),
//           ); // Center
//         },
//       ),
//     );

//     return pdf.save();
//   }

//   void _printPdf(Uint8List pdfData) {
//     Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdfData,
//     );
//   }
// }
