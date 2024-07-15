import 'package:flutter/material.dart';

Future<void> showLoadingDialog(BuildContext context, String txt) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(txt),
              )
            ],
          ),
        ),
      );
    },
  );
}

String apiBaseURL = '';

// รายการสาขาทั้งหมด
String getApiBaseUrlBranchList() {
  return '$apiBaseURL/api/v1/queue-mobile/branch-list';
}

// รายการจุดออกบัตรคิว หลังเลือก สาขา
String getApiBaseUrlTicketKioskList() {
  return '$apiBaseURL/api/v1/queue-mobile/ticket-kiosk-list';
}

// รายละเอียดข้อมูลจุดออกบัตรคิว
String getApiBaseUrlTicketKioskDetail() {
  return '$apiBaseURL/api/v1/queue-mobile/ticket-kiosk-detail';
}

// สรา้งคิว
String getApiBaseUrlCreateQueue() {
  return '$apiBaseURL/api/v1/queue-mobile/create-queue';
}

// ดูรายการคิว
String getApiBaseUrlSearchQueue() {
  return '$apiBaseURL/api/v1/queue-mobile/search-queue';
}

// Call Queue
String getApiBaseUrlCallQueue() {
  return '$apiBaseURL/api/v1/queue-mobile/call-queue';
}

// Check Queue
String getApiBaseUrlCallerQueue() {
  return '$apiBaseURL/api/v1/queue-mobile/caller-queue';
}

// Check รายการ คอลทั้งหมดที่มี
String getApiBaseUrlCallerQueueAll() {
  return '$apiBaseURL/api/v1/queue-mobile/caller-queue-all';
}

// Update Queue
String getApiBaseUrlUpdateQueue() {
  return '$apiBaseURL/api/v1/queue-mobile/update-queue';
}

String getApiBaseUrlRenderDisplay() {
  return '$apiBaseURL/api/v1/queue-mobile/render-display';
}

final String branchListUrl = getApiBaseUrlBranchList();
final String ticketKioskListUrl = getApiBaseUrlTicketKioskList();
final String ticketKioskDetailUrl = getApiBaseUrlTicketKioskDetail();
final String createQueueUrl = getApiBaseUrlCreateQueue();
final String searchQueueUrl = getApiBaseUrlSearchQueue();
final String callQueueUrl = getApiBaseUrlCallQueue();
final String callerQueueUrl = getApiBaseUrlCallerQueue();
final String callerQueueAllUrl = getApiBaseUrlCallerQueueAll();
final String updateQueueUrl = getApiBaseUrlUpdateQueue();

final String renderDisplay = getApiBaseUrlRenderDisplay();
