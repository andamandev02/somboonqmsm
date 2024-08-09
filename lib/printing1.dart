import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class TestPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  Future<Uint8List> imagePathToUint8List(String path) async {
    ByteData data = await rootBundle.load(path);
    Uint8List imageBytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return imageBytes;
  }

  Future<void> sample(
      BuildContext context, Map<String, dynamic> _qrData) async {
    ByteData bytesData = await rootBundle.load("assets/logo/images.jpg");
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = await File('$dir/logo.png').writeAsBytes(bytesData.buffer
        .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes));
    final imageBytes = await imagePathToUint8List('assets/logo/images.jpg');
    bool? isConnected = await bluetooth.isConnected;

    ///image from Network
    var response = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/kakzaki/blue_thermal_printer/master/example/assets/images/yourlogo.png"));
    Uint8List bytesNetwork = response.bodyBytes;
    Uint8List imageBytesFromNetwork = bytesNetwork.buffer
        .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes);

    if (isConnected == true) {
      bluetooth.printImage(file.path);
      bluetooth.printImageBytes(imageBytesFromNetwork,600,600);
      bluetooth.printCustom(
          "Branch : ${_qrData['data']['branch']['branch_name']}", 3, 1);
      bluetooth.printCustom(
          "Queue No : ${_qrData['data']['queue']['queue_no']}", 3, 1);
      bluetooth.printCustom(
          "${_qrData['data']['queue']['number_pax']} PAX", 3, 1);
      bluetooth.printCustom("${_qrData['data']['queue']['queue_time']}", 3, 1);
      bluetooth.printCustom("If your number has passed ,", 0, 1);
      bluetooth.printCustom("Please get a new ticket.", 0, 1);
      bluetooth.printCustom("Everyone must be here to be seated.", 0, 1);
      bluetooth.printCustom("Scan to see the current number.", 0, 1);
      bluetooth.paperCut();
    } else {
      // Handle the case when the printer is not connected
      print("Printer is not connected.");
    }
  }
}
