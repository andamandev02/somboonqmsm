import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:somboonqms/url_api.dart';

class ClassTicket {
  static Future<void> ticketkiosk({
    required BuildContext context,
    required String branchid,
    required Function(List<Map<String, dynamic>>) onTicketKioskLoaded,
  }) async {
    try {
      final queryParameters = {
        'branchid': branchid,
      };
      final response = await http.get(
        Uri.parse(ticketKioskListUrl).replace(queryParameters: queryParameters),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<Map<String, dynamic>> kioskList = (jsonData['data'] as List)
            .map((item) => item as Map<String, dynamic>)
            .map((item) {
          item['t_kiosk_id'] = item['t_kiosk_id']?.toString();
          item['branch_id'] = item['branch_id']?.toString();
          item['t_kiosk_name'] = item['t_kiosk_name']?.toString();
          item['t_kiosk_label'] = item['t_kiosk_label']?.toString();
          item['t_kiosk_btn_row'] = item['t_kiosk_btn_row']?.toString();
          item['t_kiosk_btn_column'] = item['t_kiosk_btn_column']?.toString();
          item['t_kiosk_btn_icon'] = item['t_kiosk_btn_icon']?.toString();
          item['t_kiosk_display_id'] = item['t_kiosk_display_id']?.toString();
          item['t_kiosk_status'] = item['t_kiosk_status']?.toString();
          item['kiosk_id'] = item['kiosk_id']?.toString();
          item['t_kiosk_display_name'] =
              item['t_kiosk_display_name']?.toString();
          item['t_display_type'] = item['t_display_type']?.toString();
          item['display_h'] = item['display_h']?.toString();
          item['display_v'] = item['display_v']?.toString();
          item['t_kiosk_display_status'] =
              item['t_kiosk_display_status']?.toString();
          return item;
        }).toList();

        onTicketKioskLoaded(kioskList);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> ticketkioskdetail({
    required BuildContext context,
    required String branchid,
    required Function(List<Map<String, dynamic>>) onTicketKioskDetailLoaded,
  }) async {
    try {
      final queryParameters = {
        'branchid': branchid,
      };
      final uri = Uri.parse(ticketKioskDetailUrl)
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
          List<Map<String, dynamic>> ticketKioskDetailList =
              (jsonData['data'] as List)
                  .map((item) => item as Map<String, dynamic>)
                  .toList();
          onTicketKioskDetailLoaded(ticketKioskDetailList);
        } else {
          onTicketKioskDetailLoaded([]);
        }
      } else {
        print('Failed to load service. Status code: ${response.statusCode}');
        onTicketKioskDetailLoaded([]);
      }
    } catch (e) {
      print('Error occurred: $e');
      onTicketKioskDetailLoaded([]);
    }
  }
}
