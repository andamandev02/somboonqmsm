import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:somboonqms/crud/branch/ticketkiosk.dart';
import 'package:somboonqms/crud/queue/crud.dart';
import 'package:somboonqms/reprinting.dart';

class TabsAllScreen extends StatefulWidget {
  final List<Map<String, dynamic>> SearchQueue;
  final Map<String, dynamic> Branch;
  const TabsAllScreen({
    super.key,
    required this.SearchQueue,
    required this.Branch,
  });

  @override
  State<TabsAllScreen> createState() => _TabsAllScreenState();
}

class _TabsAllScreenState extends State<TabsAllScreen> {
  String? _selectedReason;

  @override
  void initState() {
    super.initState();
    fetchReason(widget.Branch['branch_id']);
  }

  late List<Map<String, dynamic>> Reason = [];
  bool isLoading = true;

  Future<void> fetchReason(String branchid) async {
    await ClassTicket.EndQueueReasonlist(
      context: context,
      branchid: branchid,
      onReasonLoaded: (loadedReason) {
        setState(() {
          Reason = loadedReason;
          isLoading = false;
        });
      },
    );
  }

  String formatQueueTime(String queueTime) {
    try {
      List<String> parts = queueTime.split(':');
      String hours = parts[0];
      String minutes = parts[1];
      return '$hours:$minutes';
    } catch (e) {
      return 'Invalid time';
    }
  }

  String formatDateTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      String formattedTime = DateFormat('H:mm').format(dateTime);
      return formattedTime;
    } catch (e) {
      return 'Invalid time';
    }
  }

  String calculateTimeDifference(String queueTime) {
    DateTime now = DateTime.now();
    DateTime parsedTime = DateTime(now.year, now.month, now.day,
        int.parse(queueTime.split(":")[0]), int.parse(queueTime.split(":")[1]));
    Duration difference = now.difference(parsedTime);
    int differenceInSeconds = difference.inSeconds;
    int hours = difference.inHours;
    int minutes = (differenceInSeconds % 3600) ~/ 60;
    int seconds = differenceInSeconds % 60;
    // return '${hours}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return '${hours}:${minutes.toString().padLeft(2, '0')}';
  }

  Widget buildTimeText(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    return Expanded(
      flex: 2,
      child: Text(
        '${DateFormat('H:mm').format(dateTime)}',
        style: const TextStyle(
          fontSize: 14,
          color: Color.fromRGBO(9, 159, 175, 1.0),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: widget.SearchQueue.length,
      itemBuilder: (BuildContext context, int index) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        final item = widget.SearchQueue[index];
        if (item['service_status_id'] == '1') {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                minimumSize: Size(
                    double.infinity, MediaQuery.of(context).size.height * 0.09),
                side:
                    const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'WAIT',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              item['queue_no'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '(จำนวน)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${item['number_pax']} PAX',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '(ออกคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${formatQueueTime(item['queue_time'])}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '(พักคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${item['hold_time'] ?? '-'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '(เวลารอ)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  calculateTimeDifference(item['queue_time']),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Expanded(
                        //   child: ElevatedButton(
                        //     onPressed: () async {
                        //       // showDialog(
                        //       //   context: context,
                        //       //   barrierDismissible: false,
                        //       //   builder: (BuildContext context) {
                        //       //     return const Dialog(
                        //       //       backgroundColor: Colors.transparent,
                        //       //       child: Center(
                        //       //         child: CircularProgressIndicator(),
                        //       //       ),
                        //       //     );
                        //       //   },
                        //       // );

                        //       // await ClassQueue().UpdateQueue(
                        //       //   context: context,
                        //       //   SearchQueue: [item],
                        //       //   StatusQueue: 'Finishing',
                        //       // );
                        //       _showSaveDialog(context, [item]);
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       foregroundColor: Colors.white,
                        //       backgroundColor: Color.fromARGB(255, 255, 0, 0),
                        //       padding:
                        //           const EdgeInsets.symmetric(vertical: 20.0),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10.0),
                        //       ),
                        //     ),
                        //     child: const Text(
                        //       'จบคิว',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 20.0,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await ClassQueue().CallQueue(
                                context: context,
                                SearchQueue: [item],
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromRGBO(9, 159, 175, 1.0),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'เรียกคิว',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
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
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.05),
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
                                            'กำลังทำการ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.08,
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          Text(
                                            'พิมพ์บัตรคิว',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.08,
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              await showQRCodeDialog(context, item);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(255, 5, 97, 21),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'บัตรคิว',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (item['service_status_id'] == '2') {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: ElevatedButton(
              onPressed: () {},
              onLongPress: () {
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
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                minimumSize: Size(
                    double.infinity, MediaQuery.of(context).size.height * 0.09),
                side:
                    const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'CALL',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              item['queue_no'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '(จำนวน)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${item['number_pax']} PAX',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '(ออกคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${formatQueueTime(item['queue_time'])}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await ClassQueue().UpdateQueue(
                                context: context,
                                SearchQueue: [item],
                                StatusQueue: 'Holding',
                                StatusQueueNote: Reason[index]['reason_id'],
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromRGBO(249, 162, 31, 1), //
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'พักคิว',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(width: 5.0),
                        // Expanded(
                        //   child: ElevatedButton(
                        //     onPressed: () async {
                        //       // showDialog(
                        //       //   context: context,
                        //       //   barrierDismissible: false,
                        //       //   builder: (BuildContext context) {
                        //       //     return const Dialog(
                        //       //       backgroundColor: Colors.transparent,
                        //       //       child: Center(
                        //       //         child: CircularProgressIndicator(),
                        //       //       ),
                        //       //     );
                        //       //   },
                        //       // );

                        //       // await ClassQueue().UpdateQueue(
                        //       //   context: context,
                        //       //   SearchQueue: [item],
                        //       //   StatusQueue: 'Finishing',
                        //       // );
                        //       _showSaveDialog(context, [item]);
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       foregroundColor: Colors.white,
                        //       backgroundColor: Color.fromARGB(255, 255, 0, 0),
                        //       padding:
                        //           const EdgeInsets.symmetric(vertical: 20.0),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10.0),
                        //       ),
                        //     ),
                        //     child: const Text(
                        //       'จบคิว',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 20.0,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await ClassQueue().UpdateQueue(
                                context: context,
                                SearchQueue: [item],
                                StatusQueue: 'Recalling',
                                StatusQueueNote: Reason[index]['reason_id'],
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Color.fromARGB(255, 0, 84, 180), //
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'เรียกซ้ำ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
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
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.05),
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
                                            'กำลังทำการ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.08,
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          Text(
                                            'พิมพ์บัตรคิว',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.08,
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              await showQRCodeDialog(context, item);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(255, 5, 97, 21),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'บัตรคิว',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (item['service_status_id'] == '3') {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                minimumSize: Size(
                    double.infinity, MediaQuery.of(context).size.height * 0.09),
                side:
                    const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'HOLD',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              item['queue_no'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '(จำนวน)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${item['number_pax']} PAX',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '(ออกคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${formatQueueTime(item['queue_time'])}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '(พักคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${formatQueueTime(item['hold_time'])}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Expanded(
                        //   child: ElevatedButton(
                        //     onPressed: () async {
                        //       // showDialog(
                        //       //   context: context,
                        //       //   barrierDismissible: false,
                        //       //   builder: (BuildContext context) {
                        //       //     return const Dialog(
                        //       //       backgroundColor: Colors.transparent,
                        //       //       child: Center(
                        //       //         child: CircularProgressIndicator(),
                        //       //       ),
                        //       //     );
                        //       //   },
                        //       // );

                        //       // await ClassQueue().UpdateQueue(
                        //       //   context: context,
                        //       //   SearchQueue: [item],
                        //       //   StatusQueue: 'Finishing',
                        //       // );
                        //       _showSaveDialog(context, [item]);
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       foregroundColor: Colors.white,
                        //       backgroundColor: Color.fromARGB(255, 255, 0, 0),
                        //       padding:
                        //           const EdgeInsets.symmetric(vertical: 20.0),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10.0),
                        //       ),
                        //     ),
                        //     child: const Text(
                        //       'จบคิว',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 20.0,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await ClassQueue().UpdateQueue(
                                context: context,
                                SearchQueue: [item],
                                StatusQueue: 'Calling',
                                StatusQueueNote: Reason[index]['reason_id'],
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromRGBO(9, 159, 175, 1.0),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'เรียกคิว',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
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
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.05),
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
                                            'กำลังทำการ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.08,
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          Text(
                                            'พิมพ์บัตรคิว',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.08,
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                              await showQRCodeDialog(context, item);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(255, 5, 97, 21),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'บัตรคิว',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (item['service_status_id'] == '9') {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                minimumSize: Size(
                    double.infinity, MediaQuery.of(context).size.height * 0.09),
                side:
                    const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'END',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item['queue_no'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  '(พักคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${item['number_pax']} PAX',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  '(ออกคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${formatQueueTime(item['queue_time'])}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  '(พักคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '-',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  '(จบคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${formatDateTime(item['updated_at'])}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                minimumSize: Size(
                    double.infinity, MediaQuery.of(context).size.height * 0.09),
                side:
                    const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'FINIS',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              item['queue_no'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  '(พักคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${item['number_pax']} PAX',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  '(ออกคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${formatQueueTime(item['queue_time'])}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  '(พักคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item['hold_time'] != null
                                      ? formatQueueTime(item['hold_time'])
                                      : '-',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  '(จบคิว)',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item['end_time'] != null
                                      ? formatQueueTime(item['end_time'])
                                      : '-',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void _showSaveDialog(
      BuildContext context, List<Map<String, dynamic>> linkedQueue) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: screenWidth * 0.9, // กำหนดความกว้างของ Dialog
            padding: EdgeInsets.all(20.0), // เพิ่ม padding รอบๆ
            child: Column(
              mainAxisSize: MainAxisSize.min, // ปรับขนาดของ Column ตามเนื้อหา
              children: [
                Center(
                  child: Text(
                    'บันทึกสิ้นสุดรายการ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(9, 159, 175, 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 20), // เพิ่มระยะห่างระหว่าง title และเนื้อหา
                Reason.isEmpty
                    ? Center(
                        child: Text(
                          'ไม่มีรายการร้องขอ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.025,
                          ),
                        ),
                      )
                    : Wrap(
                        spacing: 10, // ระยะห่างระหว่างปุ่ม
                        runSpacing: 10, // ระยะห่างระหว่างแถวของปุ่ม
                        children: List.generate(
                          Reason.length,
                          (index) {
                            if (Reason[index]['reason_id'] == '1') {
                              return ElevatedButton(
                                onPressed: () async {
                                  var ReasonNote = '';
                                  if (Reason[index]['reason_id'] == '1') {
                                    ReasonNote = 'Finishing';
                                  } else {
                                    ReasonNote = 'Ending';
                                  }

                                  await ClassQueue().UpdateQueue(
                                    context: context,
                                    SearchQueue: linkedQueue,
                                    StatusQueue: ReasonNote,
                                    StatusQueueNote: Reason[index]['reason_id'],
                                  );

                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      const Color.fromRGBO(9, 159, 175, 1.0),
                                  minimumSize: Size(
                                      screenWidth * 0.8, screenHeight * 0.1),
                                  shape: RoundedRectangleBorder(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${Reason[index]['reson_name']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenHeight *
                                            0.025, // ปรับขนาดข้อความตามขนาดหน้าจอ
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return ElevatedButton(
                                onPressed: () async {
                                  var ReasonNote = '';
                                  if (Reason[index]['reason_id'] == '1') {
                                    ReasonNote = 'Finishing';
                                  } else {
                                    ReasonNote = 'Ending';
                                  }

                                  await ClassQueue().UpdateQueue(
                                    context: context,
                                    SearchQueue: linkedQueue,
                                    StatusQueue: ReasonNote,
                                    StatusQueueNote: Reason[index]['reason_id'],
                                  );

                                  Timer(Duration(seconds: 2), () {
                                    Navigator.of(context).pop();
                                    // Navigator.of(context).pop();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      Color.fromARGB(255, 219, 118, 2),
                                  minimumSize: Size(
                                      screenWidth * 0.8, screenHeight * 0.1),
                                  shape: RoundedRectangleBorder(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${Reason[index]['reson_name']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenHeight *
                                            0.025, // ปรับขนาดข้อความตามขนาดหน้าจอ
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                    minimumSize: Size(screenWidth * 0.8, screenHeight * 0.1),
                    shape: RoundedRectangleBorder(),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ปิดหน้าต่าง',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: screenHeight *
                              0.025, // ปรับขนาดข้อความตามขนาดหน้าจอ
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSaveDialog1(BuildContext context, List<Map<String, dynamic>> item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: screenWidth * 0.9, // กำหนดความกว้างของ Dialog
            padding: EdgeInsets.all(20.0), // เพิ่ม padding รอบๆ
            child: Column(
              mainAxisSize: MainAxisSize.min, // ปรับขนาดของ Column ตามเนื้อหา
              children: [
                Center(
                  child: Text(
                    'บันทึกสิ้นสุดรายการ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(9, 159, 175, 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 20), // เพิ่มระยะห่างระหว่าง title และเนื้อหา
                Reason.isEmpty
                    ? Center(
                        child: Text(
                          'ไม่มีรายการร้องขอ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.025,
                          ),
                        ),
                      )
                    : Wrap(
                        spacing: 10, // ระยะห่างระหว่างปุ่ม
                        runSpacing: 10, // ระยะห่างระหว่างแถวของปุ่ม
                        children: List.generate(
                          Reason.length,
                          (index) => ElevatedButton(
                            onPressed: () async {
                              var ReasonNote = '';
                              if (Reason[index]['reason_id'] == '1') {
                                ReasonNote = 'Finishing';
                              } else {
                                ReasonNote = 'Ending';
                              }

                              await ClassQueue().UpdateQueue(
                                context: context,
                                SearchQueue: item,
                                StatusQueue: ReasonNote,
                                StatusQueueNote: Reason[index]['reason_id'],
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  const Color.fromRGBO(9, 159, 175, 1.0),
                              minimumSize:
                                  Size(screenWidth * 0.8, screenHeight * 0.1),
                              side: BorderSide(color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${Reason[index]['reson_name']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenHeight *
                                        0.025, // ปรับขนาดข้อความตามขนาดหน้าจอ
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                    minimumSize: Size(screenWidth * 0.8, screenHeight * 0.1),
                    side: BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ปิดหน้าต่าง',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: screenHeight *
                              0.025, // ปรับขนาดข้อความตามขนาดหน้าจอ
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
