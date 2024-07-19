import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  final FlutterBlue ble = FlutterBlue.instance;
  final _scanResults = <ScanResult>[].obs;

  @override
  void onInit() {
    super.onInit();
    ble.scanResults.listen((results) {
      _scanResults.assignAll(results);
    });
  }

  Future<void> scanDevices() async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted) {
      ble.startScan(timeout: const Duration(seconds: 15));
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(timeout: const Duration(seconds: 15));
      device.state.listen((state) {
        if (state == BluetoothDeviceState.connecting) {
          print("Device connecting to: ${device.name}");
        } else if (state == BluetoothDeviceState.connected) {
          print("Device connected: ${device.name}");
        } else {
          print("Device Disconnected");
        }
      });
    } catch (e) {
      print("Connection error: $e");
    }
  }

  Stream<List<ScanResult>> get scanResults => ble.scanResults;
}
