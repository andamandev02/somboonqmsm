import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:somboonqms/crud/queue/crud.dart';
import 'package:somboonqms/url_api.dart';

class TabsWaitingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> SearchQueue;
  const TabsWaitingScreen({
    super.key,
    required this.SearchQueue,
  });

  @override
  State<TabsWaitingScreen> createState() => _TabsWaitingScreenState();
}

class _TabsWaitingScreenState extends State<TabsWaitingScreen> {
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

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    List<dynamic> todayQueue = widget.SearchQueue.where((queue) {
      DateTime queueDate = DateTime.parse(queue['queue_date']);
      return queueDate.year == today.year &&
          queueDate.month == today.month &&
          queueDate.day == today.day;
    }).toList();
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: todayQueue.length,
      itemBuilder: (BuildContext context, int index) {
        final item = todayQueue[index];
        if (item['service_status_id'] == '1') {
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
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
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
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${item['number_pax']} PAX',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${formatQueueTime(item['queue_time'])}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(9, 159, 175, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
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

                              await ClassQueue().UpdateQueue(
                                context: context,
                                SearchQueue: [item],
                                StatusQueue: 'Finishing',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(255, 255, 0, 0),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'End',
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
                                  return const Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              );

                              await ClassQueue().CallQueue(
                                context: context,
                                SearchQueue: [item],
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromRGBO(9, 159, 175, 1.0),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Call',
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
        } else {
          return Container();
        }
      },
    );
  }
}
