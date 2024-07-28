// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:somboonqms/printer/Qrcode.dart';
// import 'package:somboonqms/url_api.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketService {
//   IO.Socket? socket;
//   String connectionStatus = "Disconnected";

//   Future<void> connectSocket({
//     required BuildContext context,
//     required List<Map<String, dynamic>> callerData,
//   }) async {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     try {
//       socket = IO.io(
//         // 'https://somboonqms.andamandev.com',
//         SOCKET_IO_HOST,
//         IO.OptionBuilder()
//             .setTransports(['websocket'])
//             .setPath(SOCKET_IO_PATH)
//             .setExtraHeaders({'Connection': 'upgrade', 'Upgrade': 'websocket'})
//             .enableForceNew()
//             .build(),
//       );

//       socket?.onConnect((_) {
//         print('Connection established');
//         connectionStatus = "Connected";
//         _emitRecallData(callerData);
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             AlertDialog alert = AlertDialog(
//               content: Text(
//                 "เรียกคิวซ้ำสำเร็จ",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: screenWidth * 0.02,
//                   color: Color.fromRGBO(9, 159, 175, 1.0),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             );
//             return alert;
//           },
//         );
//         Navigator.of(context).pop();
//         Navigator.of(context).pop();
//       });

//       socket?.onDisconnect((_) {
//         print('Connection Disconnected');
//         connectionStatus = "Disconnected";
//       });

//       socket?.onConnectError((err) {
//         print('Connect Error: $err');
//         connectionStatus = "Connection Error: $err";
//       });

//       socket?.onError((err) {
//         print('Error: $err');
//         connectionStatus = "Error: $err";
//       });

//       socket?.connect();
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   void _emitRecallData(List<Map<String, dynamic>> data) {
//     if (socket != null && data.isNotEmpty) {
//       print('emit: socket is not null or data is not empty.');
//       socket?.emit('call', <String, dynamic>{'queue': 'call', 'data': data});
//     } else {
//       print('Failed to emit: socket is null or data is empty.');
//     }
//   }
// }

// ignore_for_file: unused_import

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
  String PCSC_INITIAL = "PCSC_INITIAL";
  String PCSC_CLOSE = "PCSC_CLOSE";

  String DEVICE_WAITING = "DEVICE_WAITING";
  String DEVICE_CONNECTED = "DEVICE_CONNECTED";
  String DEVICE_ERROR = "DEVICE_ERROR";
  String DEVICE_DISCONNECTED = "DEVICE_DISCONNECTED";

  String CARD_INSERTED = "CARD_INSERTED";
  String CARD_REMOVED = "CARD_REMOVED";

  String READING_INIT = "READING_INIT";
  String READING_START = "READING_START";
  String READING_PROGRESS = "READING_PROGRESS";
  String READING_COMPLETE = "READING_COMPLETE";
  String READING_FAIL = "READING_FAIL";
  String REGISTER = "queue:register";
  String CALL = "queue:call";
  String HOLD = "queue:hold";
  String FINISH = "queue:finish";
  String START = "queue:start";
  String TRANSFER = "queue:transfer";

  String SETTING_DISPLAY = "setting:display";
  String SETTING_COUNTER = "setting:counter";
  String SETTING_BRANCH_SERVICE = "setting:branch-service";
  String SETTING_SERVICE = "setting:service";
  String SETTING_KIOSK = "setting:kiosk";
  String CHECK_FOR_UPDATE = "check-for-update";

  String DISPLAY_PLAYING = "display:playing";
  String DISPLAY_ENDED = "display:ended";
  String DISPLAY_UPDATE_STATUS = "display:update-status";

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
        socket?.emit(
            CALL, <String, dynamic>{'queue': 'call', 'data': callerData});
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
      // print('emit: socket is not null or data is not empty.');
      print("recall");
      socket?.emit(CALL, <String, dynamic>{'queue': 'call', 'data': data});
      socket?.onDisconnect((_) {
        print('Connection Disconnected');
        connectionStatus = "Disconnected";
      });
      socket?.onError((err) => print(err));
    } else {
      print('Failed to emit: socket is null or data is empty.');
    }
  }
}
