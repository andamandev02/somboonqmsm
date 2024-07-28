import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:somboonqms/connect/setthing.dart';
import 'package:somboonqms/printing.dart';
import 'package:somboonqms/url_api.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../printer/pdf.dart';

class ClassQueue {
  IO.Socket? socket;

  Future<void> createQueue({
    required BuildContext context,
    required String Pax,
    required Map<String, dynamic> TicketKioskDetail,
    required Map<String, dynamic> Branch,
    required Map<String, dynamic> Kiosk,
  }) async {
    // Use MediaQuery within the method using the passed context
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    try {
      var body = jsonEncode({
        'Pax': Pax,
        'TicketKioskDetail': jsonEncode(TicketKioskDetail),
        'Branch': jsonEncode(Branch),
        'Kiosk': jsonEncode(Kiosk),
      });

      final response = await http.post(
        Uri.parse(createQueueUrl),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> _qrData = jsonDecode(response.body);
        Timer(Duration(seconds: 2), () {
          TestPrint testPrint = TestPrint();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewTicket(_qrData), // Pass qrData
            ),
          ).then((_) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });

          // showQRCodeDialog(context, _qrData);
          // testPrint.sample(context, _qrData);
        });
        // print(response.body);
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     AlertDialog alert = AlertDialog(
        //       content: Text(
        //         response.body,
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           fontSize: screenWidth * 0.07,
        //           color: Color.fromRGBO(9, 159, 175, 1.0),
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     );

        //     return alert;
        //   },
        // );
      } else {
        // print('Response body: ${response.body}');
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            AlertDialog alert = AlertDialog(
              content: Text(
                response.body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: Color.fromRGBO(9, 159, 175, 1.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
            Timer(Duration(seconds: 2), () {
              Navigator.of(context).pop();
            });

            return alert;
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> CallQueue(
      {required BuildContext context,
      required List<Map<String, dynamic>> SearchQueue}) async {
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

      var body = jsonEncode({
        'SearchQueue': jsonEncode(SearchQueue),
      });

      final response = await http.post(
        Uri.parse(callQueueUrl),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        Map<String, dynamic> data = jsonData['data'];
        Map<String, dynamic> queue = data['queue'];
        String queueNo = queue['queue_no'];

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Colors.white,
              content: Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Color.fromRGBO(255, 0, 0, 1),
                      size: screenWidth * 0.2,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'กำลังเรียกคิว',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        color: Color.fromRGBO(9, 159, 175, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      queueNo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.10,
                        color: Color.fromRGBO(9, 159, 175, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        socket?.onConnect((_) {
          print('Connection established');
          connectionStatus = "Connected";
          socket?.emit(
              CALL, <String, dynamic>{'queue': 'call', 'data': jsonData});
        });

        Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
          DefaultTabController.of(context).animateTo(0);
        });
      } else if (response.statusCode == 422) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Colors.white,
              content: Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Color.fromRGBO(255, 0, 0, 1),
                      size: screenWidth * 0.2,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'มีคิวที่กำลังใช้งานอยู่',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        color: Color.fromRGBO(9, 159, 175, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'กรุณาเคลียคิวให้เสร็จสิ้น',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            AlertDialog alert = AlertDialog(
              content: Text(
                response.body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  color: Color.fromRGBO(9, 159, 175, 1.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );

            // Timer(Duration(seconds: 2), () {
            //   Navigator.of(context).pop();
            // });

            return alert;
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> UpdateQueue(
      {required BuildContext context,
      required List<Map<String, dynamic>> SearchQueue,
      required String StatusQueue,
      required String StatusQueueNote}) async {
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

      var body = jsonEncode({
        'SearchQueue': jsonEncode(SearchQueue),
        'StatusQueue': jsonEncode(StatusQueue),
        'StatusQueueNote': jsonEncode(StatusQueueNote),
      });

      final response = await http.post(
        Uri.parse(updateQueueUrl),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        var ToSocket = '';
        String ToMsg = '';
        if (StatusQueue == 'Calling') {
          ToSocket = CALL;
          ToMsg = "กำลังเรียกคิว";
        } else if (StatusQueue == 'Holding') {
          ToSocket = HOLD;
          ToMsg = "กำลังพักคิว";
        } else if (StatusQueue == 'Ending') {
          ToSocket = FINISH;
          ToMsg = "กำลังยกเลิกคิว";
        } else if (StatusQueue == 'Finishing') {
          ToSocket = FINISH;
          ToMsg = "กำลังจบคิว";
        } else if (StatusQueue == 'Recalling') {
          ToSocket = CALL;
          ToMsg = "กำลังเรียกคิวซ้ำ";
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.white,
                content: Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Color.fromRGBO(255, 0, 0, 1),
                        size: screenWidth * 0.2,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        ToMsg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.07,
                          color: Color.fromRGBO(9, 159, 175, 1.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        jsonData['data']['data']['queue']['queue_no'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.10,
                          color: Color.fromRGBO(9, 159, 175, 1.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          Timer(Duration(seconds: 2), () {
            Navigator.of(context).pop();
            DefaultTabController.of(context).animateTo(0);
          });
        });

        socket?.onConnect((_) {
          print('Connection established');
          connectionStatus = "Connected";
          socket?.emit(ToSocket,
              <String, dynamic>{'queue': ToSocket, 'data': jsonData['data']});
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
      } else if (response.statusCode == 422) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.white,
                content: Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Color.fromRGBO(255, 0, 0, 1),
                        size: screenWidth * 0.2,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'มีคิวที่กำลังใช้งานอยู่',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          color: Color.fromRGBO(9, 159, 175, 1.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'กรุณาเคลียคิวให้เสร็จสิ้น',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          Timer(Duration(seconds: 2), () {
            Navigator.of(context, rootNavigator: true).pop();
          });
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              AlertDialog alert = AlertDialog(
                content: Text(
                  response.body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Color.fromRGBO(9, 159, 175, 1.0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
              return alert;
            },
          );

          Timer(Duration(seconds: 2), () {
            Navigator.of(context, rootNavigator: true).pop();
          });
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> RecallQueue(
      {required BuildContext context,
      required List<Map<String, dynamic>> SearchQueue,
      required String StatusQueue}) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    try {
      var body = jsonEncode({
        'SearchQueue': jsonEncode(SearchQueue),
        'StatusQueue': jsonEncode(StatusQueue),
      });

      final response = await http.post(
        Uri.parse(updateQueueUrl),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: body,
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          AlertDialog alert = AlertDialog(
            content: Text(
              response.body,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: Color.fromRGBO(9, 159, 175, 1.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          return alert;
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> searchqueue({
    required BuildContext context,
    required String branchid,
    required Function(List<Map<String, dynamic>>) onSearchQueueLoaded,
  }) async {
    try {
      final queryParameters = {
        'branchid': branchid,
      };
      final uri =
          Uri.parse(searchQueueUrl).replace(queryParameters: queryParameters);
      final response = await http.get(
        uri,
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       content: Text(
        //         response.body,
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           fontSize: 20,
        //           color: Color.fromRGBO(9, 159, 175, 1.0),
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     );
        //   },
        // );
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] is List) {
          List<Map<String, dynamic>> searchQueueList =
              (jsonData['data'] as List)
                  .map((item) => item as Map<String, dynamic>)
                  .toList();
          onSearchQueueLoaded(searchQueueList);
        } else {
          onSearchQueueLoaded([]);
        }
      } else {
        print('Failed to load service. Status code: ${response.statusCode}');
        onSearchQueueLoaded([]);
      }
    } catch (e) {
      print('Error occurred: $e');
      onSearchQueueLoaded([]);
    }
  }

  Future<void> CallerQueue({
    required BuildContext context,
    required Map<String, dynamic> TicketKioskDetail,
    required Map<String, dynamic> Branch,
    required Map<String, dynamic> Kiosk,
    required Function(List<Map<String, dynamic>>) onCallerLoaded,
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

      var body = jsonEncode({
        'TicketKioskDetail': TicketKioskDetail,
        'Branch': Branch,
        'Kiosk': Kiosk,
      });
      final response = await http.post(
        // Uri.parse(callerQueueUrl),
        Uri.parse(callQueueUrl),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        Map<String, dynamic> data = jsonData['data'];
        Map<String, dynamic> innerData = data['data'];
        Map<String, dynamic> innerDataS = innerData['queue'];
        String queueNo = innerDataS['queue_no'].toString();
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.white,
                content: Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Color.fromRGBO(255, 0, 0, 1),
                        size: screenWidth * 0.2,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'กำลังเรียกคิว',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          color: Color.fromRGBO(9, 159, 175, 1.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        queueNo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.10,
                          color: Color.fromRGBO(9, 159, 175, 1.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          socket?.onConnect((_) {
            print('Connection established');
            connectionStatus = "Connected";
            socket?.emit(
                CALL, <String, dynamic>{'queue': 'call', 'data': jsonData});
          });

          var bodyrender = jsonEncode({
            'RenderDisplay': response.body,
          });

          final responserender = await http.post(
            Uri.parse(renderDisplay),
            headers: <String, String>{
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
            },
            body: bodyrender,
          );

          // if (jsonData.containsKey('data') &&
          //     jsonData['data'] is Map<String, dynamic>) {
          //   Map<String, dynamic> data = jsonData['data'];
          //   List<Map<String, dynamic>> callerList = [
          //     data['caller'],
          //     data['callertrans'],
          //     data['queue']
          //   ];
          //   onCallerLoaded(callerList);
          // } else {
          //   onCallerLoaded([]);
          // }

          if (innerData.containsKey('data') &&
              innerData['data'] is Map<String, dynamic>) {
            Map<String, dynamic> data = innerData['data'];
            List<Map<String, dynamic>> callerList = [
              data['caller'],
              data['callertrans'],
              data['queue']
            ];
            onCallerLoaded(callerList);
          } else {
            onCallerLoaded([]);
          }

          socket?.onConnectError((err) {
            print('Connect Error: $err');
            connectionStatus = "Connection Error: $err";
          });

          socket?.onError((err) {
            print('Error: $err');
            connectionStatus = "Error: $err";
          });

          socket?.connect();

          Timer(Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
        });
      } else if (response.statusCode == 422) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Colors.white,
              content: Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Color.fromRGBO(255, 0, 0, 1),
                      size: screenWidth * 0.2,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'มีคิวที่กำลังใช้งานอยู่',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        color: Color.fromRGBO(9, 159, 175, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'กรุณาเคลียคิวให้เสร็จสิ้น',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      } else if (response.statusCode == 421) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Colors.white,
              content: Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Color.fromRGBO(255, 0, 0, 1),
                      size: screenWidth * 0.2,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'ไม่มีรายการคิว',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        color: Color.fromRGBO(9, 159, 175, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'กรุณาโปรดเตรียมคิว',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        Timer(Duration(seconds: 2), () {
          // Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            AlertDialog alert = AlertDialog(
              content: Text(
                response.body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: Color.fromRGBO(9, 159, 175, 1.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
            return alert;
          },
        );
      }
    } catch (e) {
      print('เกิดข้อผิดพลาด: $e');
    }
  }

  static Future<void> CallerQueueAll({
    required BuildContext context,
    required String branchid,
    required Function(List<Map<String, dynamic>>) onCallerQueueAllLoaded,
  }) async {
    try {
      final queryParameters = {
        'branchid': branchid,
      };
      final uri = Uri.parse(callerQueueAllUrl)
          .replace(queryParameters: queryParameters);
      final response = await http.get(
        uri,
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('data') && jsonData['data'] is List) {
          List<Map<String, dynamic>> CallerQueueAllList =
              (jsonData['data'] as List)
                  .map((item) => item as Map<String, dynamic>)
                  .toList();
          onCallerQueueAllLoaded(CallerQueueAllList);
        } else {
          onCallerQueueAllLoaded([]);
        }
      } else {
        print('Failed to load service. Status code: ${response.statusCode}');
        onCallerQueueAllLoaded([]);
      }
    } catch (e) {
      print('Error occurred: $e');
      onCallerQueueAllLoaded([]);
    }
  }
}
