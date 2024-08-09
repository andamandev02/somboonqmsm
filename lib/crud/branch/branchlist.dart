import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:somboonqms/url_api.dart';

class ClassBranch {
  static Future<void> branchlist({
    required BuildContext context,
    required Function(List<Map<String, dynamic>>) onBranchListLoaded,
  }) async {
    try {
      final response = await http.get(
        // Uri.parse(branchListUrl),
        Uri.parse(
            'https://somboonqms.andamandev.com/api/v1/queue-mobile/branch-list'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<Map<String, dynamic>> branchList = (jsonData['data'] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
        onBranchListLoaded(branchList);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            AlertDialog alert = AlertDialog(
              content: Text(
                'เกิดปัญหาในการสร้างคิว',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 0.07,
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
}
