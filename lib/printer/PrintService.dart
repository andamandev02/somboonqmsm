import 'package:flutter/services.dart';

class NyxPrinterService {
  static const MethodChannel _channel = MethodChannel('nyx_printer_plugin');

  static Future<void> printHelloWorld() async {
    try {
      await _channel.invokeMethod('printHelloWorld');
    } on PlatformException catch (e) {
      print("Failed to print: '${e.message}'.");
    }
  }
}
