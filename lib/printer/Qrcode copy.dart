// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// void showQRCodeDialog(BuildContext context, Map<String, dynamic> _qrData) {
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Center(
//           child: pw.Column(
//             mainAxisAlignment: pw.MainAxisAlignment.center,
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             children: [
//               pw.Text(
//                 'Branch: ${_qrData['data']['branch']['branch_name']}',
//                 style: pw.TextStyle(fontSize: 16.0),
//               ),
//               pw.Text(
//                 'Queue No: ${_qrData['data']['queue']['queue_no']}',
//                 style: pw.TextStyle(fontSize: 50.0, fontWeight: pw.FontWeight.bold),
//               ),
//               pw.Text(
//                 '${_qrData['data']['queue']['number_pax']} PAX',
//                 style: pw.TextStyle(fontSize: 16.0),
//               ),
//               pw.Text(
//                 'Queue Time: ${_qrData['data']['queue']['queue_time']}',
//                 style: pw.TextStyle(fontSize: 16.0),
//               ),
//               pw.Text(
//                 'If your number has passed, Please get a new ticket.',
//                 style: pw.TextStyle(fontSize: 8.0),
//               ),
//               pw.Text(
//                 '如果您的号码通过了请获取新票。',
//                 style: pw.TextStyle(fontSize: 16.0),
//               ),
//               // pw.Image(
//               //   pw.MemoryImage(
//               //     qrData['data']['queuetrans']['queue_id'].toString().codeUnits,
//               //   ),
//               // ),
//               pw.Text(
//                 'Scan to see the current number.',
//                 style: pw.TextStyle(fontSize: 16.0),
//               ),
//               pw.Text(
//                 'Wait 10 Queue',
//                 style: pw.TextStyle(fontSize: 16.0),
//               ),
//             ],
//           ),
//         );
//       },
//     ),
//   );

//   // Convert PDF to Uint8List
//   final pdfData = await pdf.save();

//   // Print the PDF using printing package
//   Printing.layoutPdf(
//     onLayout: (PdfPageFormat format) async => pdfData,
//     name: 'my_document.pdf',
//   );
  
//   // showDialog(
//   //   context: context,
//   //   builder: (BuildContext context) {
//   //     return AlertDialog(
//   //       content: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         children: [
//   //           Container(
//   //             width: 150.0,
//   //             height: 150.0,
//   //             child: Image.asset(
//   //               'assets/logo/logoprint.png',
//   //               fit: BoxFit.scaleDown,
//   //             ),
//   //           ),
//   //           SizedBox(height: 5.0),
//   //           Text(
//   //             'Branch: ${_qrData['data']['branch']['branch_name'].toString()}',
//   //             style: TextStyle(fontSize: 16.0),
//   //           ),
//   //           SizedBox(height: 5.0),
//   //           Text(
//   //             '${_qrData['data']['queue']['queue_no'].toString()}',
//   //             style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
//   //           ),
//   //           SizedBox(height: 5.0),
//   //           Text(
//   //             '${_qrData['data']['queue']['number_pax'].toString()} PAX',
//   //             style: TextStyle(fontSize: 16.0),
//   //           ),
//   //           SizedBox(height: 5.0),
//   //           Text(
//   //             '${_qrData['data']['queue']['queue_time'].toString()}',
//   //             style: TextStyle(fontSize: 16.0),
//   //           ),
//   //           SizedBox(height: 20.0),
//   //           Text(
//   //             'If your number has passed, Please get a new ticket.',
//   //             style: TextStyle(fontSize: 8.0),
//   //           ),
//   //           SizedBox(height: 5.0),
//   //           Text(
//   //             '如果您的号码通过了请获取新票。',
//   //             style: TextStyle(fontSize: 16.0),
//   //           ),
//   //           Container(
//   //             width: 150.0,
//   //             height: 150.0,
//   //             child: QrImageView(
//   //               data:
//   //                   'https://somboonqms.andamandev.com/api/v1/queue-mobile/qr-code?queue_id=${_qrData['data']['queuetrans']['queue_id'].toString()}',
//   //               version: QrVersions.auto,
//   //               // size: 50.0,
//   //             ),
//   //           ),
//   //           SizedBox(height: 5.0),
//   //           Text(
//   //             'Scan to see the current number.',
//   //             style: TextStyle(fontSize: 16.0),
//   //           ),
//   //           SizedBox(height: 5.0),
//   //           Text(
//   //             'Wait 10 Queue',
//   //             style: TextStyle(fontSize: 16.0),
//   //           ),
//   //         ],
//   //       ),
//   //       actions: <Widget>[
//   //         TextButton(
//   //           child: Text('Close'),
//   //           onPressed: () {
//   //             Navigator.of(context).pop();
//   //           },
//   //         ),
//   //       ],
//   //     );
//   //   },
//   // );
// }
