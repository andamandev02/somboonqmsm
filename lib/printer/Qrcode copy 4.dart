// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:hive/hive.dart';
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

// Future<void> _PrintTicket(String device, Map<String, dynamic> _qrData) async {
//   try {
//     BluetoothConnection connection =
//         await BluetoothConnection.toAddress(device);
//     print('Connected to the device');

//     final profile = await CapabilityProfile.load();
//     final printer = Generator(PaperSize.mm80, profile);

//     final Uint8List logoBytes = await rootBundle
//         .load('assets/icon/icon.png')
//         .then((data) => data.buffer.asUint8List());

//     String qrDataUrl =
//         'https://somboonqms.andamandev.com/en/app/kiosk/scan-queue?id=';
//     final Uint8List qrBytes = await createQrImage(
//         '$qrDataUrl${_qrData['data']['queue']['queue_id']}', 200.0);

//     final img.Image qrImage = img.decodeImage(qrBytes)!;
//     final img.Image lgImage = img.decodeImage(logoBytes)!;

//     final List<int> bytes = [];

//     // เพิ่มรูปภาพโลโก้เพียงครั้งเดียว ปรับขนาดให้เหมาะสม
//     bytes.addAll(printer.image(img.copyResize(lgImage, width: 80, height: 80)));

//     // เพิ่มข้อความ

//     bytes.addAll(printer.text(
//       'Branch: ${_qrData['data']['branch']['branch_name']}',
//       styles: PosStyles(
//         align: PosAlign.center,
//         height: PosTextSize.size2,
//         width: PosTextSize.size2,
//       ),
//     ));

//     bytes.addAll(printer.text(
//       'Queue No: ${_qrData['data']['queue']['queue_no']}',
//       styles: PosStyles(
//         align: PosAlign.center,
//         height: PosTextSize.size1,
//         width: PosTextSize.size1,
//       ),
//     ));

//     bytes.addAll(printer.text(
//       '${_qrData['data']['queue']['number_pax']} PAX',
//       styles: PosStyles(
//         align: PosAlign.center,
//         height: PosTextSize.size1,
//         width: PosTextSize.size1,
//       ),
//     ));

//     bytes.addAll(printer.text(
//       '${_qrData['data']['queue']['queue_time']}',
//       styles: PosStyles(
//         align: PosAlign.center,
//         height: PosTextSize.size1,
//         width: PosTextSize.size1,
//       ),
//     ));

//     bytes.addAll(printer.text(
//       'If your number has passed,',
//       styles: PosStyles(
//         align: PosAlign.center,
//         height: PosTextSize.size1,
//         width: PosTextSize.size1,
//       ),
//     ));

//     bytes.addAll(printer.text(
//       'Please get a new ticket.',
//       styles: PosStyles(
//         align: PosAlign.center,
//         height: PosTextSize.size1,
//         width: PosTextSize.size1,
//       ),
//     ));

//     // เพิ่ม QR Code เพียงครั้งเดียว ปรับขนาดให้เหมาะสม
//     bytes.addAll(printer.image(img.copyResize(qrImage, width: 80, height: 80)));

//     bytes.addAll(printer.text(
//       'Everyone must be here to be seated.',
//       styles: PosStyles(
//         align: PosAlign.center,
//         height: PosTextSize.size1,
//         width: PosTextSize.size1,
//       ),
//     ));

//     bytes.addAll(printer.text(
//       'Scan to see the current number.',
//       styles: PosStyles(
//         align: PosAlign.center,
//         height: PosTextSize.size1,
//         width: PosTextSize.size1,
//       ),
//     ));

//     bytes.addAll(printer.text(
//       'Wait Queue',
//       styles: PosStyles(
//         align: PosAlign.center,
//         height: PosTextSize.size1,
//         width: PosTextSize.size1,
//       ),
//     ));

//     // ตัดกระดาษ
//     bytes.addAll(printer.cut());

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
