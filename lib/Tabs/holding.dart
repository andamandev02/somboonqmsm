import 'dart:async';

import 'package:flutter/material.dart';
import 'package:somboonqms/crud/branch/ticketkiosk.dart';
import 'package:somboonqms/crud/queue/crud.dart';

class TabsHoldScreen extends StatefulWidget {
  final List<Map<String, dynamic>> SearchQueue;
  final Map<String, dynamic> Branch;
  const TabsHoldScreen({
    super.key,
    required this.SearchQueue,
    required this.Branch,
  });

  @override
  State<TabsHoldScreen> createState() => _TabsHoldScreenState();
}

class _TabsHoldScreenState extends State<TabsHoldScreen> {
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

  String calculateTimeDifference(String queueTime) {
    DateTime now = DateTime.now();
    DateTime parsedTime = DateTime(now.year, now.month, now.day,
        int.parse(queueTime.split(":")[0]), int.parse(queueTime.split(":")[1]));
    Duration difference = now.difference(parsedTime);
    int differenceInMinutes = difference.inMinutes;
    if (differenceInMinutes < 60) {
      return '${differenceInMinutes} น.';
    } else {
      int hours = differenceInMinutes ~/ 60;
      int remainingMinutes = differenceInMinutes % 60;
      return '${hours}:${remainingMinutes}';
    }
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: widget.SearchQueue.length,
      itemBuilder: (BuildContext context, int index) {
        final item = widget.SearchQueue[index];
        if (item['service_status_id'] == '3') {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: ElevatedButton(
              onPressed: () async {},
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item['queue_no'],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
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
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '(สร้างคิว)',
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
                          SizedBox(width: 15),
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
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // showDialog(
                              //   context: context,
                              //   barrierDismissible: false,
                              //   builder: (BuildContext context) {
                              //     return const Dialog(
                              //       backgroundColor: Colors.transparent,
                              //       child: Center(
                              //         child: CircularProgressIndicator(),
                              //       ),
                              //     );
                              //   },
                              // );

                              // await ClassQueue().UpdateQueue(
                              //   context: context,
                              //   SearchQueue: [item],
                              //   StatusQueue: 'Finishing',
                              // );
                              _showSaveDialog(context, [item]);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(
                                  255, 255, 0, 0), // สีข้อความของปุ่ม
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'จบคิว',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
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
                                fontSize: 20.0,
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
        } else {
          return Container();
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

                                  Timer(Duration(seconds: 2), () {
                                    Navigator.of(context).pop();
                                  });
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
}
