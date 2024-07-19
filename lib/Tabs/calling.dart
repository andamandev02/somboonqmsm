import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:somboonqms/crud/queue/crud.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:somboonqms/crud/socket.dart';

class TabsCallingScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final Map<String, dynamic> Kiosk;
  // ignore: non_constant_identifier_names
  final Map<String, dynamic> Branch;
  // ignore: non_constant_identifier_names
  final List<Map<String, dynamic>> TicketKioskDetail;
  final List<Map<String, dynamic>> SearchQueue;
  const TabsCallingScreen({
    super.key,
    // ignore: non_constant_identifier_names
    required this.Branch,
    // ignore: non_constant_identifier_names
    required this.Kiosk,
    // ignore: non_constant_identifier_names
    required this.TicketKioskDetail,
    // ignore: non_constant_identifier_names
    required this.SearchQueue,
  });

  @override
  State<TabsCallingScreen> createState() => _TabsCallingScreenState();
}

class _TabsCallingScreenState extends State<TabsCallingScreen> {
  final TextEditingController _textPaxontroller = TextEditingController();
  // ignore: non_constant_identifier_names
  late List<Map<String, dynamic>> CallerList = [];
  // ignore: non_constant_identifier_names
  late List<Map<String, dynamic>> QueueAll = [];
  final List<String> _dropdownItems = ['Item 1', 'Item 2', 'Item 3'];
  // ignore: unused_field
  String? _selectedValue;
  Timer? _timer;
  // ignore: unused_field
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // รันรายการ caller
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchCallerQueueAll(widget.Branch['branch_id']);
    });
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

  Future<void> fetchCallerQueueAll(String branchid) async {
    await ClassQueue.CallerQueueAll(
      context: context,
      branchid: branchid,
      onCallerQueueAllLoaded: (loadedCallerQueueAll) {
        if (mounted) {
          setState(() {
            QueueAll = loadedCallerQueueAll;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _textPaxontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double baseFontSize = screenSize.height * 0.065;
    final double fontSize = baseFontSize * 11.5;
    final double letterSpacing = screenSize.width * 0.05;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(5),
          itemCount: widget.TicketKioskDetail.length,
          itemBuilder: (BuildContext context, int index) {
            final T1 = widget.TicketKioskDetail[index];
            final T2 = QueueAll;
            List<Widget> queueWidgets = [];

            // ถ้า T2 ว่างเปล่า ให้แสดงเฉพาะ T1
            if (T2 == null || T2.isEmpty) {
              queueWidgets.add(
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white, // สีข้อความและไอคอน
                    minimumSize: Size(
                        double.infinity,
                        MediaQuery.of(context).size.height *
                            0.2), // ขนาดปุ่มให้เต็มแนวขวางและสูง 20% ของหน้าจอ
                    side: BorderSide(color: Colors.white), // สีขอบปุ่ม
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // ลดความโค้งของปุ่มลง
                    ),
                    alignment: Alignment.centerLeft, // จัดข้อความไปทางซ้าย
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0), // เพิ่ม padding
                  ),
                  // child: Text('No data available in QueueAll')),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Service',
                                  style: TextStyle(
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  '${widget.TicketKioskDetail[index]['service_group_name']}',
                                  style: TextStyle(
                                      color: Color.fromRGBO(9, 159, 175, 1.0),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${widget.TicketKioskDetail[index]['t_kiosk_btn_name']}',
                                  style: TextStyle(
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // คอลัมที่ 2
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Waiting',
                                  style: TextStyle(
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  '',
                                  style: TextStyle(
                                      color: Color.fromRGBO(9, 159, 175, 1.0),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '',
                                  style: TextStyle(
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // คอลัมที่ 3
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextField(
                                  readOnly: true,
                                  textAlign: TextAlign
                                      .center, // จัดข้อความให้อยู่ตรงกลาง
                                  decoration: InputDecoration(
                                    hintText: '',
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(9, 159, 175, 1.0),
                                      fontSize: 25.0,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0), // ลดความสูงของ input
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // ทำขอบโค้งมน
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(9, 159, 175, 1.0),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(9, 159, 175,
                                            1.0), // สีขอบเมื่อ focus
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // แถวล่าง
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _showNumpadDialog(
                                      context, widget.TicketKioskDetail[index]);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color.fromRGBO(
                                      9, 159, 175, 1.0), // สีข้อความของปุ่ม
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal:
                                          20.0), // ปรับ margin ด้านในปุ่ม
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // ความโค้งมนของปุ่ม
                                  ),
                                ),
                                child: const Text(
                                  'ADD Q',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly, // กระจายปุ่มให้มีระยะห่างเท่ากัน
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {},
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Color.fromARGB(255, 117,
                                          117, 117), // สีข้อความของปุ่ม
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // ความโค้งมนของปุ่ม
                                      ),
                                    ),
                                    child: const Text(
                                      'Hold',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: 5.0), // เพิ่มช่องว่างระหว่างปุ่ม
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // เพิ่มการทำงานของปุ่ม End
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Color.fromARGB(255, 117,
                                          117, 117), // สีข้อความของปุ่ม
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // ความโค้งมนของปุ่ม
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
                                const SizedBox(
                                    width: 5.0), // เพิ่มช่องว่างระหว่างปุ่ม
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
                                      //         child:
                                      //             CircularProgressIndicator(),
                                      //       ),
                                      //     );
                                      //   },
                                      // );

                                      await ClassQueue().CallerQueue(
                                        context: context,
                                        TicketKioskDetail:
                                            widget.TicketKioskDetail[index],
                                        Branch: widget.Branch,
                                        Kiosk: widget.Kiosk,
                                        onCallerLoaded: (loadedSearchQueue) {
                                          setState(() {
                                            CallerList = loadedSearchQueue;
                                          });
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          Color.fromRGBO(9, 159, 175, 1.0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical:
                                              10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // ความโค้งมนของปุ่ม
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
                    ],
                  ),
                ),
              );
            } else {
              // กรอง T2 เพื่อหาข้อมูลที่ตรงกับ T1
              final linkedQueue = T2
                  .where((queue) =>
                      queue['branch_service_group_id'] ==
                      T1['branch_service_group_id'])
                  .toList();

              // ถ้าไม่มีข้อมูลที่สัมพันธ์กัน ให้แสดงข้อความว่าไม่มีรายการที่สัมพันธ์กัน
              if (linkedQueue.isEmpty) {
                // queueWidgets.add(Text(
                //     'มี T2 แต่ไม่ใช่ รายการนี้: ${T1['branch_service_group_id']}'));
                queueWidgets.add(
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white, // สีข้อความและไอคอน
                      minimumSize: Size(
                          double.infinity,
                          MediaQuery.of(context).size.height *
                              0.2), // ขนาดปุ่มให้เต็มแนวขวางและสูง 20% ของหน้าจอ
                      side: BorderSide(color: Colors.white), // สีขอบปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // ลดความโค้งของปุ่มลง
                      ),
                      alignment: Alignment.centerLeft, // จัดข้อความไปทางซ้าย
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0), // เพิ่ม padding
                    ),
                    // child: Text('No data available in QueueAll')),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Service',
                                    style: TextStyle(
                                      color: Color.fromRGBO(9, 159, 175, 1.0),
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Text(
                                    '${widget.TicketKioskDetail[index]['service_group_name']}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(9, 159, 175, 1.0),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${widget.TicketKioskDetail[index]['t_kiosk_btn_name']}',
                                    style: TextStyle(
                                      color: Color.fromRGBO(9, 159, 175, 1.0),
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // คอลัมที่ 2
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Waiting',
                                    style: TextStyle(
                                      color: Color.fromRGBO(9, 159, 175, 1.0),
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        color: Color.fromRGBO(9, 159, 175, 1.0),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                      color: Color.fromRGBO(9, 159, 175, 1.0),
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // คอลัมที่ 3
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextField(
                                    readOnly: true,
                                    textAlign: TextAlign
                                        .center, // จัดข้อความให้อยู่ตรงกลาง
                                    decoration: InputDecoration(
                                      hintText: '',
                                      hintStyle: TextStyle(
                                        color: Color.fromRGBO(9, 159, 175, 1.0),
                                        fontSize: 25.0,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical:
                                                  10.0), // ลดความสูงของ input
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // ทำขอบโค้งมน
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(9, 159, 175, 1.0),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color.fromRGBO(9, 159, 175,
                                              1.0), // สีขอบเมื่อ focus
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Color.fromRGBO(9, 159, 175, 1.0),
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // แถวล่าง
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showNumpadDialog(context,
                                        widget.TicketKioskDetail[index]);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color.fromRGBO(
                                        9, 159, 175, 1.0), // สีข้อความของปุ่ม
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal:
                                            20.0), // ปรับ margin ด้านในปุ่ม
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // ความโค้งมนของปุ่ม
                                    ),
                                  ),
                                  child: const Text(
                                    'ADD Q',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly, // กระจายปุ่มให้มีระยะห่างเท่ากัน
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // เพิ่มการทำงานของปุ่ม Hold
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Color.fromARGB(255, 117, 117, 117),
                                        padding: const EdgeInsets.symmetric(
                                            vertical:
                                                10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // ความโค้งมนของปุ่ม
                                        ),
                                      ),
                                      child: const Text(
                                        'Hold',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 5.0), // เพิ่มช่องว่างระหว่างปุ่ม
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // เพิ่มการทำงานของปุ่ม End
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Color.fromARGB(255, 117, 117, 117),
                                        padding: const EdgeInsets.symmetric(
                                            vertical:
                                                10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // ความโค้งมนของปุ่ม
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
                                  const SizedBox(
                                      width: 5.0), // เพิ่มช่องว่างระหว่างปุ่ม
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return const Dialog(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          },
                                        );

                                        await ClassQueue().CallerQueue(
                                          context: context,
                                          TicketKioskDetail:
                                              widget.TicketKioskDetail[index],
                                          Branch: widget.Branch,
                                          Kiosk: widget.Kiosk,
                                          onCallerLoaded: (loadedSearchQueue) {
                                            setState(() {
                                              CallerList = loadedSearchQueue;
                                            });
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Color.fromRGBO(9, 159, 175, 1.0),
                                        padding: const EdgeInsets.symmetric(
                                            vertical:
                                                10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // ความโค้งมนของปุ่ม
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
                      ],
                    ),
                  ),
                );
              } else {
                // แสดงข้อมูลของรายการที่สัมพันธ์กันจาก T2
                linkedQueue.forEach((queue) {
                  queueWidgets.add(
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.green, // สีข้อความและไอคอน
                        minimumSize: Size(
                            double.infinity,
                            MediaQuery.of(context).size.height *
                                0.2), // ขนาดปุ่มให้เต็มแนวขวางและสูง 20% ของหน้าจอ
                        side: BorderSide(color: Colors.white), // สีขอบปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // ลดความโค้งของปุ่มลง
                        ),
                        alignment: Alignment.centerLeft, // จัดข้อความไปทางซ้าย
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0), // เพิ่ม padding
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // แถวบน
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Service',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      '${widget.TicketKioskDetail[index]['service_group_name']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${widget.TicketKioskDetail[index]['t_kiosk_btn_name']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // คอลัมที่ 2
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Waiting',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      // // widget.SearchQueue.queue_id ==
                                      // //         widget.TicketKioskDetail[index]
                                      // //             ['queue_id']
                                      // //     ? 'yes'
                                      // //     : 'no',
                                      // widget.SearchQueue['queue_id'].toString(),
                                      '${queue['queue_count']}',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Text(
                                    //   '${calculateTimeDifference(QueueAll[index]['queue_time'])}',
                                    //   style: TextStyle(
                                    //     color: Colors.white,
                                    //     fontSize: 12.0,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              // คอลัมที่ 3
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextField(
                                      readOnly: true,
                                      textAlign: TextAlign
                                          .center, // จัดข้อความให้อยู่ตรงกลาง
                                      decoration: InputDecoration(
                                        hintText: '${queue['queue_no']}',
                                        hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical:
                                                    10.0), // ลดความสูงของ input
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // ทำขอบโค้งมน
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color.fromRGBO(9, 159, 175,
                                                1.0), // สีขอบเมื่อ focus
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // แถวล่าง
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // คอลัมที่ 1
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showNumpadDialog(context,
                                          widget.TicketKioskDetail[index]);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color.fromRGBO(
                                          9, 159, 175, 1.0), // สีข้อความของปุ่ม
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal:
                                              20.0), // ปรับ margin ด้านในปุ่ม
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // ความโค้งมนของปุ่ม
                                      ),
                                    ),
                                    child: const Text(
                                      'ADD Q',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // คอลัมที่ 2
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly, // กระจายปุ่มให้มีระยะห่างเท่ากัน
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return const Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            },
                                          );

                                          await ClassQueue().UpdateQueue(
                                            context: context,
                                            SearchQueue: linkedQueue,
                                            StatusQueue: 'Holding',
                                          );
                                          // Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color.fromRGBO(
                                              249,
                                              162,
                                              31,
                                              1), // สีข้อความของปุ่ม
                                          padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0), // ความโค้งมนของปุ่ม
                                          ),
                                        ),
                                        child: const Text(
                                          'Hold',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 5.0), // เพิ่มช่องว่างระหว่างปุ่ม
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _showSaveDialog(context, linkedQueue);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              Color.fromARGB(255, 255, 0, 0),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                    const SizedBox(
                                        width: 5.0), // เพิ่มช่องว่างระหว่างปุ่ม
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return const Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            },
                                          );

                                          await SocketService().connectSocket(
                                            context: context,
                                            callerData: linkedQueue,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              Color.fromRGBO(9, 159, 175, 1.0),
                                          padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0), // ความโค้งมนของปุ่ม
                                          ),
                                        ),
                                        child: const Text(
                                          'Recall',
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
                        ],
                      ),
                    ),
                  );
                });
              }
            }
            // แสดงข้อมูล T1
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              padding: const EdgeInsets.symmetric(horizontal: 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: queueWidgets,
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSaveDialog(
      BuildContext context, List<Map<String, dynamic>> linkedQueue) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'บันทึกการสิ้นสุดรายการ',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(9, 159, 175, 1.0),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(),
              SizedBox(height: 10),
              ElevatedButton(
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
                    SearchQueue:
                        linkedQueue, // Adjust this based on your map structure
                    StatusQueue: 'Finishing',
                  );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
                ),
                child: Center(
                  child: Text('เข้ารับบริการเรียบร้อย'),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
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
                    SearchQueue:
                        linkedQueue, // Adjust this based on your map structure
                    StatusQueue: 'Ending',
                  );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 255, 0, 0),
                ),
                child: Center(
                  child: Text('ยกเลิกรายการ'),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 255, 0, 0),
                    ),
                    child: Center(
                      child: Text('ปิด'),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _showNumpadDialog(
      BuildContext context, Map<String, dynamic> TicketKioskDetail) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

        double paddingValue = screenWidth * 0.05;
        double textFieldHeight = screenHeight * 0.05;
        double buttonSize = (screenWidth - paddingValue * 4) / 3;
        double fontSize = buttonSize * 0.4;

        TextEditingController _textPaxController = TextEditingController();

        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        'Service ${TicketKioskDetail['service_group_name']} Seats',
                        style: TextStyle(
                          fontSize: fontSize * 0.65,
                          color: Color.fromRGBO(9, 159, 175, 1.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: paddingValue * 1.0),
                    Row(
                      children: [
                        Text(
                          "ระบุ",
                          style: TextStyle(
                            fontSize: fontSize * 0.5,
                            color: Color.fromRGBO(9, 159, 175, 1.0),
                          ),
                        ),
                        SizedBox(width: paddingValue),
                        Expanded(
                          child: Container(
                            height: textFieldHeight,
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingValue * 0.1),
                            child: TextField(
                              controller: _textPaxController,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: '',
                                hintStyle: TextStyle(
                                  color: Color.fromRGBO(9, 159, 175, 1.0),
                                  fontSize: fontSize * 0.3,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: paddingValue * 0.1),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(paddingValue * 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(paddingValue * 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(paddingValue * 2),
                                ),
                              ),
                              style: TextStyle(
                                  color: Color.fromRGBO(9, 159, 175, 1.0),
                                  fontSize: fontSize * 0.5),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: paddingValue),
                        Text(
                          "คน",
                          style: TextStyle(
                            fontSize: fontSize * 0.5,
                            color: Color.fromRGBO(9, 159, 175, 1.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: paddingValue * 1.0),
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: paddingValue * 0.5,
                          crossAxisSpacing: paddingValue * 0.5,
                        ),
                        itemCount: 12,
                        itemBuilder: (BuildContext context, int index) {
                          String buttonText;
                          Color buttonColor;
                          if (index < 9) {
                            buttonText = '${index + 1}';
                            buttonColor = Color.fromRGBO(9, 159, 175, 1.0);
                          } else if (index == 9) {
                            buttonText = '';
                            buttonColor = Colors.transparent;
                          } else if (index == 10) {
                            buttonText = '0';
                            buttonColor = Color.fromRGBO(9, 159, 175, 1.0);
                          } else {
                            buttonText = '←';
                            buttonColor = Color.fromRGBO(9, 159, 175, 1.0);
                          }
                          return ElevatedButton(
                            onPressed: () {
                              if (buttonText == '←') {
                                if (_textPaxController.text.isNotEmpty) {
                                  _textPaxController.text =
                                      _textPaxController.text.substring(0,
                                          _textPaxController.text.length - 1);
                                }
                              } else if (buttonText.isNotEmpty) {
                                _textPaxController.text += buttonText;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(buttonSize, buttonSize),
                              padding: EdgeInsets.all(paddingValue * 1.0),
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(paddingValue),
                              ),
                            ),
                            child: buttonText.isEmpty
                                ? SizedBox.shrink()
                                : Text(
                                    buttonText,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: buttonText == '←'
                                          ? fontSize * 0.75
                                          : fontSize,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: paddingValue),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromRGBO(255, 0, 0, 1),
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              'ยกเลิก',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_textPaxController.text.isEmpty ||
                                  TicketKioskDetail.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    AlertDialog alert = AlertDialog(
                                      content: Text(
                                        'ป้อนจำนวนคน',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.07,
                                          color:
                                              Color.fromRGBO(9, 159, 175, 1.0),
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
                              } else {
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

                                await ClassQueue().createQueue(
                                  context: context,
                                  Pax: _textPaxController.text,
                                  TicketKioskDetail: TicketKioskDetail,
                                  Branch: widget.Branch,
                                  Kiosk: widget.Kiosk,
                                );

                                Timer(Duration(seconds: 1), () async {
                                  _textPaxController.text = '';
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await Future.delayed(Duration(seconds: 1));
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromRGBO(9, 159, 175, 1.0),
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              'บันทึกรายการ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
