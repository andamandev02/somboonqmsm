// // queue_service.dart
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:somboonqms/crud/queue/crud.dart';

// class QueueService {
//   final BuildContext context;
//   final String branchId;
//   QueueService({required this.context, required this.branchId});

//   Future<List<Map<String, dynamic>>> fetchSearchQueue() async {
//     Completer<List<Map<String, dynamic>>> completer = Completer();

//     await ClassQueue.searchqueue(
//       context: context,
//       branchid: branchId,
//       onSearchQueueLoaded: (loadedSearchQueue) {
//         completer.complete(loadedSearchQueue);
//       },
//     );

//     return completer.future;
//   }
// }
