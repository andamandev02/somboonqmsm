import 'dart:isolate';

Future<void> computeInIsolate(SendPort sendPort) async {
  await Future.delayed(Duration(seconds: 2));
  sendPort.send('Data processed');
}
