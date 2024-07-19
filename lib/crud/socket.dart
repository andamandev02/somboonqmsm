import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:somboonqms/printer/Qrcode.dart';
import 'package:somboonqms/url_api.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;
  String connectionStatus = "Disconnected";

  Future<void> connectSocket({
    required BuildContext context,
    required List<Map<String, dynamic>> callerData,
  }) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    try {
      socket = IO.io(
        // 'https://somboonqms.andamandev.com',
        SOCKET_IO_HOST,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setPath(SOCKET_IO_PATH)
            .setExtraHeaders({'Connection': 'upgrade', 'Upgrade': 'websocket'})
            .enableForceNew()
            .build(),
      );

      socket?.onConnect((_) {
        print('Connection established');
        connectionStatus = "Connected";
        _emitRecallData(callerData);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            AlertDialog alert = AlertDialog(
              content: Text(
                "เรียกคิวซ้ำสำเร็จ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.02,
                  color: Color.fromRGBO(9, 159, 175, 1.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
            return alert;
          },
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });

      socket?.onDisconnect((_) {
        print('Connection Disconnected');
        connectionStatus = "Disconnected";
      });

      socket?.onConnectError((err) {
        print('Connect Error: $err');
        connectionStatus = "Connection Error: $err";
      });

      socket?.onError((err) {
        print('Error: $err');
        connectionStatus = "Error: $err";
      });

      socket?.connect();
    } catch (e) {
      print('Error: $e');
    }
  }

  void _emitRecallData(List<Map<String, dynamic>> data) {
    if (socket != null && data.isNotEmpty) {
      print('emit: socket is not null or data is not empty.');
      socket?.emit('call', <String, dynamic>{'queue': 'call', 'data': data});
    } else {
      print('Failed to emit: socket is null or data is empty.');
    }
  }
}
