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

String getApiBaseUrlQueueFirstTicketKioskList() {
  return '$apiBaseURL/api/v1/queue-mobile/queue-first-ticket-kiosk-detail';
}

String getApiBaseUrlQueueCountFirstTicketKioskList() {
  return '$apiBaseURL/api/v1/queue-mobile/queue-count-first-ticket-kiosk-detail';
}

// รายการจบคิว
String getApiBaseUrlEndQueueList() {
  return '$apiBaseURL/api/v1/queue-mobile/reason-all';
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

// recall
String getApiBaseUrlRecallQueue() {
  return '$apiBaseURL/api/v1/queue-mobile/recall-queue';
}

String getApiBaseUrlRenderDisplay() {
  return '$apiBaseURL/api/v1/queue-mobile/render-display';
}

final String branchListUrl = getApiBaseUrlBranchList();
final String ticketKioskListUrl = getApiBaseUrlTicketKioskList();
final String queuefirstticketKioskDetailUrl =
    getApiBaseUrlQueueFirstTicketKioskList();
final String queueCountfirstticketKioskDetailUrl =
    getApiBaseUrlQueueCountFirstTicketKioskList();
final String endQueueReasonlistUrl = getApiBaseUrlEndQueueList();
final String ticketKioskDetailUrl = getApiBaseUrlTicketKioskDetail();
final String createQueueUrl = getApiBaseUrlCreateQueue();
final String searchQueueUrl = getApiBaseUrlSearchQueue();
final String callQueueUrl = getApiBaseUrlCallQueue();
final String callerQueueUrl = getApiBaseUrlCallerQueue();
final String callerQueueAllUrl = getApiBaseUrlCallerQueueAll();
final String updateQueueUrl = getApiBaseUrlUpdateQueue();
final String recallQueueUrl = getApiBaseUrlRecallQueue();

final String renderDisplay = getApiBaseUrlRenderDisplay();

const String logoUrl =
    'https://firebasestorage.googleapis.com/v0/b/sys1-319107.appspot.com/o/uploads%2Fsys-logo.png?alt=media&token=7839089c-ef38-40d5-b93f-40f89dd19aee';
const String demoToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoyLCJ1c2VybmFtZSI6InNtYXJ0Y2FyZSIsIm5hbWUiOiJTbWFydCBDYXJlIn0sIm5hbWUiOiJTbWFydCBDYXJlIiwianRpIjoyLCJpYXQiOjE2MzQ4MDg3OTgsIm5iZiI6MTYzNDgwODc5OCwiZXhwIjoxNjM0ODk1MTk4LCJpc3MiOiJodHRwczovL3d3dy5zeXNzY3JhcHF1ZXVlcy5jb20ifQ.lXkiffwKVvEdReex1LcYh2in625gGGy40zTbD9JLJYY';

const String GITHUB_CLIENT_ID = '8085ede7fb7b993b51df';
const String GITHUB_CLIENT_SECRET = 'c92d7fd359955d8be7f5c21ccc80f63eeb7c5b5d';
const String GITHUB_CALLBACK_URL =
    'https://sys1-319107.firebaseapp.com/__/auth/handler';

const String SOCKET_IO_HOST = 'https://somboonqms.andamandev.com';
// const String SOCKET_IO_HOST = 'https://540a-27-55-95-11.ngrok.io';
const String SOCKET_IO_PATH = '/nodesomboonqms/socket.io';

const String LONGDO_MAP_KEY = 'ed50eae671bfb054d5d4ef5126ebfbfa';

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
