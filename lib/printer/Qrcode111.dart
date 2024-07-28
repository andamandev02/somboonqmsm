// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:hive/hive.dart';
// import 'dart:ui' as ui;
// import 'dart:typed_data';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:image/image.dart' as img;

// Future<void> showQRCodeDialog(
//     BuildContext context, Map<String, dynamic> _qrData) async {
//   var printerBox = await Hive.openBox('PrinterDevice');
//   String? printerAddressString = printerBox.get('PrinterDevice');

//   if (printerAddressString != null) {
//     await _PrintTicket(printerAddressString, _qrData);
//   } else {
//     print('No printer address found');
//   }
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
//       gapless: true,
//     );

//     final picData = await painter.toImageData(size);
//     return picData!.buffer.asUint8List();
//   } else {
//     throw Exception('QR code generation failed');
//   }
// }

// Future<void> _PrintTicket(String device, Map<String, dynamic> _qrData) async {
//   try {
//     BluetoothConnection connection =
//         await BluetoothConnection.toAddress(device);
//     print('Connected to the device');

//     final profile = await CapabilityProfile.load();
//     final generator = Generator(PaperSize.mm58, profile);

//     List<int> bytes = [];

//     final logoBytes = await rootBundle
//         .load('assets/icon/icon.png')
//         .then((data) => data.buffer.asUint8List());

//     String qrDataUrl =
//         'https://somboonqms.andamandev.com/en/app/kiosk/scan-queue?id=';
//     final Uint8List qrBytes = await createQrImage(
//         '$qrDataUrl${_qrData['data']['queue']['queue_id']}', 200.0);

//     final img.Image qrImage = img.decodeImage(qrBytes)!;
//     final img.Image lgImage = img.decodeImage(logoBytes)!;

//     // ข้อมูลข้อความ
//     bytes +=
//         generator.text('Branch:${_qrData['data']['branch']['branch_name']}',
//             styles: PosStyles(
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//             ));
//     bytes += generator.text('Queue No:${_qrData['data']['queue']['queue_no']}',
//         styles: PosStyles(
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//         linesAfter: 1);
//     bytes += generator.text('${_qrData['data']['queue']['number_pax']} PAX',
//         styles: PosStyles(
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//         linesAfter: 1);
//     bytes += generator.text('${_qrData['data']['queue']['queue_time']}',
//         styles: PosStyles(bold: true), linesAfter: 1);
//     bytes += generator.text('If your number has passed,',
//         styles: PosStyles(reverse: true), linesAfter: 1);
//     bytes += generator.text('Please get a new ticket.',
//         styles: PosStyles(underline: true), linesAfter: 1);
//     bytes += generator.feed(1);
//     bytes += generator.text('Everyone must be here to be seated.',
//         styles: PosStyles(align: PosAlign.center), linesAfter: 1);
//     bytes += generator.text('Scan to see the current number.',
//         styles: PosStyles(align: PosAlign.center), linesAfter: 1);
//     bytes += generator.text('Wait Queue',
//         styles: PosStyles(align: PosAlign.center), linesAfter: 1);
//     bytes += generator.text('Text size 200%',
//         styles: PosStyles(
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ));
//     bytes += generator.feed(1);
//     bytes += generator.cut();

//     // ส่งข้อมูลไปยังเครื่องพิมพ์
//     connection.output.add(Uint8List.fromList(bytes));
//     await connection.output.allSent;

//     // ตัดการเชื่อมต่อ
//     await connection.finish();
//     print('Disconnected from the device');
//   } catch (e) {
//     print('Error: $e');
//   }
// }
