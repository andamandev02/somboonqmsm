import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:somboonqms/printerenum.dart'; // Import image package

class TestPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  sample() async {
    print("Starting sample function");

    // Image max 300px X 300px

    /// Image from File path
    String filename = 'images.jpg';
    ByteData bytesData = await rootBundle.load("assets/logo/images.jpg");
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = await File('$dir/$filename').writeAsBytes(bytesData.buffer
        .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes));

    /// Image from Asset
    ByteData bytesAsset = await rootBundle.load("assets/logo/images.jpg");
    Uint8List imageBytesFromAsset = bytesAsset.buffer
        .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    // Resize the image
    img.Image? image = img.decodeImage(imageBytesFromAsset);
    img.Image resizedImage = img.copyResize(image!, width: 500, height: 500);
    Uint8List resizedImageBytes =
        Uint8List.fromList(img.encodeJpg(resizedImage));

    /// Image from Network
    var response = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/kakzaki/blue_thermal_printer/master/example/assets/images/yourlogo.png"));
    Uint8List imageBytesFromNetwork = response.bodyBytes;

    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        print("Bluetooth is connected");

        bluetooth.printNewLine();
        bluetooth.printCustom("HEADER", Size.boldMedium.val, Align.center.val);
        bluetooth.printNewLine();

        // Print one image only
        // bluetooth.printImage(file.path); // Path of your image/logo
        // bluetooth.printNewLine();

        // Uncomment the below lines if you want to print the images from Asset or Network separately
        // bluetooth.printImageBytes(imageBytesFromAsset); // Image from Asset
        // bluetooth.printNewLine();
        // bluetooth.printImageBytes(imageBytesFromNetwork); // Image from Network
        // bluetooth.printNewLine();

        bluetooth.printLeftRight("LEFT", "RIGHT", Size.medium.val);
        bluetooth.printLeftRight("LEFT", "RIGHT", Size.bold.val);
        bluetooth.printLeftRight("LEFT", "RIGHT", Size.bold.val,
            format:
                "%-15s %15s %n"); // 15 is number of characters from left or right
        bluetooth.printNewLine();
        bluetooth.printLeftRight("LEFT", "RIGHT", Size.boldMedium.val);
        bluetooth.printLeftRight("LEFT", "RIGHT", Size.boldLarge.val);
        bluetooth.printLeftRight("LEFT", "RIGHT", Size.extraLarge.val);
        bluetooth.printNewLine();
        bluetooth.print3Column("Col1", "Col2", "Col3", Size.bold.val);
        bluetooth.print3Column("Col1", "Col2", "Col3", Size.bold.val,
            format:
                "%-10s %10s %10s %n"); // 10 is number of characters from left center and right
        bluetooth.printNewLine();
        bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", Size.bold.val);
        bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", Size.bold.val,
            format: "%-8s %7s %7s %7s %n");
        bluetooth.printNewLine();
        bluetooth.printCustom("čĆžŽšŠ-H-ščđ", Size.bold.val, Align.center.val,
            charset: "windows-1250");
        bluetooth.printLeftRight("Številka:", "18000001", Size.bold.val,
            charset: "windows-1250");
        bluetooth.printCustom("Body left", Size.bold.val, Align.left.val);
        bluetooth.printCustom("Body right", Size.medium.val, Align.right.val);
        bluetooth.printNewLine();
        bluetooth.printCustom("Thank You", Size.bold.val, Align.center.val);
        bluetooth.printNewLine();

        // Debug print before printing image
        print("Printing image from asset");
        bluetooth.printImageBytes(resizedImageBytes); // Path of your image/logo

        bluetooth.printNewLine();
        bluetooth.printNewLine();

        bluetooth
            .paperCut(); // Some printers not supported (sometime making image not centered)
        // bluetooth.drawerPin2(); // Or you can use bluetooth.drawerPin5();

        // Debug print after printing image
        print("Finished printing image from asset");
      } else {
        print("Bluetooth is not connected");
      }
    }).catchError((error) {
      print("Error checking Bluetooth connection: $error");
    });

    print("Sample function completed");
  }
}
