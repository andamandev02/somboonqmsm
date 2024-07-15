import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:somboonqms/printer/Qrcode.dart';
import 'package:somboonqms/url_api.dart';

class ClassQueue {
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
          showQRCodeDialog(context, _qrData);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
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
        print('Response body: ${response.body}');
        showDialog(
          context: context,
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
        Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     AlertDialog alert = AlertDialog(
        //       content: Text(
        //         response.body,
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           fontSize: screenWidth * 0.02,
        //           color: Color.fromRGBO(9, 159, 175, 1.0),
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     );
        //     return alert;
        //   },
        // );
      } else if (response.statusCode == 422) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            AlertDialog alert = AlertDialog(
              content: Text(
                'มีคิวที่กำลังใช้งานอยู่',
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
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      } else {
        showDialog(
          context: context,
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
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Dialog(
              backgroundColor: Colors.transparent,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
        Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          // Navigator.of(context).pop();
        });
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     AlertDialog alert = AlertDialog(
        //       content: Text(
        //         // 'บันทึกคิวสำเร็จ',
        //         response.body,
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           fontSize: screenWidth * 0.05,
        //           color: Color.fromRGBO(9, 159, 175, 1.0),
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     );
        //     return alert;
        //   },
        // );
      } else if (response.statusCode == 422) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            AlertDialog alert = AlertDialog(
              content: Text(
                'มีคิวที่กำลังใช้งานอยู่',
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
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      } else {
        showDialog(
          context: context,
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
        Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        // var bodyrender = jsonEncode({
        //   'RenderDisplay': response.body,
        // });

        // final responserender = await http.post(
        //   Uri.parse(renderDisplay),
        //   headers: <String, String>{
        //     HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        //   },
        //   body: bodyrender,
        // );

        // if (responserender.statusCode == 200) {
        // print(responserender.body);

        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     AlertDialog alert = AlertDialog(
        //       content: Text(
        //         // 'บันทึกคิวสำเร็จ',
        //         response.body,
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           fontSize: 5,
        //           color: Color.fromRGBO(9, 159, 175, 1.0),
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     );
        //     return alert;
        //   },
        // );

        if (jsonData.containsKey('data') &&
            jsonData['data'] is Map<String, dynamic>) {
          Map<String, dynamic> data = jsonData['data'];
          List<Map<String, dynamic>> callerList = [
            data['caller'],
            data['callertrans'],
            data['queue']
          ];
          onCallerLoaded(callerList);
        } else {
          onCallerLoaded([]);
        }
        // }
      } else if (response.statusCode == 422) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            AlertDialog alert = AlertDialog(
              content: Text(
                'มีคิวที่กำลังใช้งานอยู่',
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
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      } else {
        showDialog(
          context: context,
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
      print('${response.body}');

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
