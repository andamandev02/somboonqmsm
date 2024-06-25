import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

Future<Uint8List> createQrImage(String data, double size) async {
  final qrValidationResult = QrValidator.validate(
    data: data,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.L,
  );

  if (qrValidationResult.status == QrValidationStatus.valid) {
    final qrCode = qrValidationResult.qrCode;
    final painter = QrPainter.withQr(
      qr: qrCode!,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
      gapless: true,
    );

    final picData = await painter.toImageData(size);
    return picData!.buffer.asUint8List();
  } else {
    throw Exception('QR code generation failed');
  }
}

Future<void> showQRCodeDialog(
    BuildContext context, Map<String, dynamic> _qrData) async {
  final pdf = pw.Document();
  final Uint8List logoBytes = await rootBundle
      .load('assets/logo/logoprint.png')
      .then((data) => data.buffer.asUint8List());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double qrSize = constraints.maxWidth * 0.5;
          final double logoSize = constraints.maxWidth * 0.3;

          return FutureBuilder<Uint8List>(
            future: createQrImage(
              'https://somboonqms.andamandev.com/api/v1/queue-mobile/qr-code?queue_id=${_qrData['data']['queuetrans']['queue_id']}',
              qrSize,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No QR data available'));
              }

              final Uint8List qrBytes = snapshot.data!;
              final pdfLogoImage = pw.MemoryImage(logoBytes);
              final pdfQrImage = pw.MemoryImage(qrBytes);

              pdf.addPage(
                pw.Page(
                  build: (pw.Context context) {
                    return pw.Center(
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Image(pdfLogoImage,
                              width: logoSize, height: logoSize),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'Branch: ${_qrData['data']['branch']['branch_name']}',
                            style: pw.TextStyle(fontSize: 16.0),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'Queue No: ${_qrData['data']['queue']['queue_no']}',
                            style: pw.TextStyle(
                                fontSize: 30.0, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            '${_qrData['data']['queue']['number_pax']} PAX',
                            style: pw.TextStyle(fontSize: 16.0),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'Queue Time: ${_qrData['data']['queue']['queue_time']}',
                            style: pw.TextStyle(fontSize: 16.0),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'If your number has passed, Please get a new ticket.',
                            style: pw.TextStyle(fontSize: 8.0),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            '如果您的号码通过了请获取新票。',
                            style: pw.TextStyle(fontSize: 16.0),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Image(pdfQrImage, width: qrSize, height: qrSize),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'Scan to see the current number.',
                            style: pw.TextStyle(fontSize: 16.0),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'Wait 10 Queue',
                            style: pw.TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );

              final pdfData = pdf.save();

              Printing.layoutPdf(
                onLayout: (PdfPageFormat format) async => pdfData,
                name: 'my_document.pdf',
              );

              return AlertDialog(
                content: Text('PDF created successfully!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}
