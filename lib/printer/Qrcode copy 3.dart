// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:hive/hive.dart';
// import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';
// import 'dart:typed_data';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:image/image.dart' as img;

// Future<void> showQRCodeDialog(
//   //   BuildContext context, Map<String, dynamic> _qrData) async {
//   var printerBox = await Hive.openBox('PrinterDevice');
//   // String? printerAddressString = printerBox.get('PrinterDevice');

//   // if (printerAddressString != null) {
//   //   await _PrintTikget(printerAddressString, _qrData);
//   // } else {
//   //   print('No printer address found');
//   // }
// // }

// void _printPdf(Uint8List pdfData) {
//   Printing.layoutPdf(
//     onLayout: (PdfPageFormat format) async => pdfData,
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

//   // Load logo
//   final Uint8List logoBytes = await rootBundle
//       .load('assets/icon/icon.png')
//       .then((data) => data.buffer.asUint8List());

//   // Create QR code image
//   String qrDataUrl =
//       'https://somboonqms.andamandev.com/en/app/kiosk/scan-queue?id=';
//   final Uint8List qrBytes = await createQrImage(
//       '$qrDataUrl${_qrData['data']['queue']['queue_id']}', 200.0);
//   final pdfLogoImage = pw.MemoryImage(logoBytes);
//   final pdfQrImage = pw.MemoryImage(qrBytes);

//   final fontDataChinese =
//       await rootBundle.load('assets/fonts/NotoSansSC-Regular.ttf');
//   final fontChinese = pw.Font.ttf(fontDataChinese.buffer.asByteData());

//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.roll57,
//       build: (pw.Context context) {
//         return pw.Center(
//           child: pw.Column(
//             mainAxisAlignment: pw.MainAxisAlignment.center,
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             children: [
//               pw.Image(pdfLogoImage, width: 80, height: 80),
//               pw.SizedBox(height: 5),
//               pw.Text(
//                 'Branch: ${_qrData['data']['branch']['branch_name']}',
//                 style: pw.TextStyle(fontSize: 10.0),
//               ),
//               pw.SizedBox(height: 5),
//               pw.Text(
//                 'Queue No: ${_qrData['data']['queue']['queue_no']}',
//                 style: pw.TextStyle(
//                     fontSize: 12.0, fontWeight: pw.FontWeight.bold),
//               ),
//               pw.SizedBox(height: 5),
//               pw.Text(
//                 '${_qrData['data']['queue']['number_pax']} PAX',
//                 style: pw.TextStyle(fontSize: 10.0),
//               ),
//               pw.SizedBox(height: 5),
//               pw.Text(
//                 '${_qrData['data']['queue']['queue_time']}',
//                 style: pw.TextStyle(fontSize: 9.0),
//               ),
//               pw.SizedBox(height: 5),
//               pw.Text(
//                 'If your number has passed,',
//                 style: pw.TextStyle(fontSize: 10.0),
//               ),
//               pw.SizedBox(height: 5),
//               pw.Text(
//                 'Please get a new ticket.',
//                 style: pw.TextStyle(fontSize: 10.0),
//               ),
//               pw.SizedBox(height: 5),
//               pw.Image(pdfQrImage, width: 80, height: 80),
//               pw.SizedBox(height: 5),
//               pw.Text(
//                 'Everyone must be here to be seated.',
//                 style: pw.TextStyle(fontSize: 8.0),
//               ),
//               pw.SizedBox(height: 2),
//               pw.Text(
//                 '所有人都需要到场才能入座',
//                 style: pw.TextStyle(fontSize: 10.0, font: fontChinese),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Text(
//                 'Scan to see the current number.',
//                 style: pw.TextStyle(fontSize: 8.0),
//               ),
//               pw.SizedBox(height: 5),
//               pw.Text(
//                 'Wait  Queue',
//                 style: pw.TextStyle(fontSize: 8.0),
//               ),
//               pw.SizedBox(height: 50),
//             ],
//           ),
//         );
//       },
//     ),
//   );

//   return pdf.save();
// }
