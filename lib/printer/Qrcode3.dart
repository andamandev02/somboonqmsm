// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:typed_data';
// import 'package:qr_flutter/qr_flutter.dart';

// Future<void> showQRCodeDialog(
//     BuildContext context, Map<String, dynamic> _qrData) async {
//   final pdfData = await _createPdfWithText(_qrData);

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Queue No: ${_qrData['data']['queue']['queue_no']}'),
//         content: Container(
//           height: 350,
//           width: 500,
//           child: PDFView(
//             pdfData: pdfData,
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Close'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

// Future<Uint8List> createQrImage(String data, double size) async {
//   final qrValidationResult = QrValidator.validate(
//     data: data,
//     version: QrVersions.auto,
//     errorCorrectionLevel: QrErrorCorrectLevel.L,
//   );

//   if (qrValidationResult.status == QrValidationStatus.valid) {
//     final qrCode = qrValidationResult.qrCode;
//     final painter = QrPainter.withQr(
//       qr: qrCode!,
//       color: const Color(0xFF000000),
//       emptyColor: const Color(0xFFFFFFFF),
//       gapless: true,
//     );

//     final picData = await painter.toImageData(size);
//     return picData!.buffer.asUint8List();
//   } else {
//     throw Exception('QR code generation failed');
//   }
// }

// Future<Uint8List> _createPdfWithText(Map<String, dynamic> _qrData) async {
//   final pdf = pw.Document();

//   // โหลดโลโก้
//   final Uint8List logoBytes = await rootBundle
//       .load('assets/logo/logoprint.png')
//       .then((data) => data.buffer.asUint8List());

//   // สร้าง QR code image
//   final Uint8List qrBytes =
//   await createQrImage(_qrData['data']['queue']['queue_no'], 200.0);
//   final pdfLogoImage = pw.MemoryImage(logoBytes);
//   final pdfQrImage = pw.MemoryImage(qrBytes);

//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Center(
//           child: pw.Column(
//             mainAxisAlignment: pw.MainAxisAlignment.center,
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             children: [
//               pw.Image(pdfLogoImage, width: 150, height: 150), // เพิ่มขนาดของโลโก้
//               pw.SizedBox(height: 10), // เพิ่มขนาดของช่องว่าง
//               pw.Text(
//                 'Branch: ${_qrData['data']['branch']['branch_name']}',
//                 style: pw.TextStyle(fontSize: 24.0), // เพิ่มขนาดฟอนต์
//               ),
//               pw.SizedBox(height: 10), // เพิ่มขนาดของช่องว่าง
//               pw.Text(
//                 'Queue No: ${_qrData['data']['queue']['queue_no']}',
//                 style: pw.TextStyle(
//                     fontSize: 40.0, fontWeight: pw.FontWeight.bold), // เพิ่มขนาดฟอนต์
//               ),
//               pw.SizedBox(height: 10), // เพิ่มขนาดของช่องว่าง
//               pw.Text(
//                 '${_qrData['data']['queue']['number_pax']} PAX',
//                 style: pw.TextStyle(fontSize: 24.0), // เพิ่มขนาดฟอนต์
//               ),
//               pw.SizedBox(height: 10), // เพิ่มขนาดของช่องว่าง
//               pw.Text(
//                 'Queue Time: ${_qrData['data']['queue']['queue_time']}',
//                 style: pw.TextStyle(fontSize: 24.0), // เพิ่มขนาดฟอนต์
//               ),
//               pw.SizedBox(height: 10), // เพิ่มขนาดของช่องว่าง
//               pw.Text(
//                 'If your number has passed, Please get a new ticket.',
//                 style: pw.TextStyle(fontSize: 14.0), // เพิ่มขนาดฟอนต์
//               ),
//               pw.SizedBox(height: 10), // เพิ่มขนาดของช่องว่าง
//               pw.Image(pdfQrImage, width: 150, height: 150), // เพิ่มขนาดของ QR code
//               pw.SizedBox(height: 10), // เพิ่มขนาดของช่องว่าง
//               pw.Text(
//                 'Scan to see the current number.',
//                 style: pw.TextStyle(fontSize: 24.0), // เพิ่มขนาดฟอนต์
//               ),
//               pw.SizedBox(height: 10), // เพิ่มขนาดของช่องว่าง
//               pw.Text(
//                 'Wait 10 Queue',
//                 style: pw.TextStyle(fontSize: 24.0), // เพิ่มขนาดฟอนต์
//               ),
//             ],
//           ),
//         );
//       },
//     ),
//   );

//   return pdf.save();
// }

// void _printPdf(Uint8List pdfData) {
//   Printing.layoutPdf(
//     onLayout: (PdfPageFormat format) async => pdfData,
//   );
// }
