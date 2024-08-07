import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:somboonqms/crud/branch/ticketkiosk.dart';
import 'package:somboonqms/crud/queue/crud%20copy.dart';
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
  late List<Map<String, dynamic>> QueueFirstKioskDetail = [];
  late List<Map<String, dynamic>> QueueCountFirstKioskDetail = [];
  final List<String> _dropdownItems = ['Item 1', 'Item 2', 'Item 3'];
  // ignore: unused_field
  String? _selectedValue;
  bool _isButtonDisabled = false;
  Timer? _timer;
  // ignore: unused_field
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // รันรายการ caller
    fetchReason(widget.Branch['branch_id']);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async  {
       await fetchCallerQueueAll(widget.Branch['branch_id']);
       await fetchQueueFirstKioskDetail(widget.Branch['branch_id']);
       await fetchQueueCountFirstKioskDetail(widget.Branch['branch_id']);
    });
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

  Future<void> fetchQueueFirstKioskDetail(String branchid) async {
    await ClassTicket.QueueFirstticketkioskdetail(
      context: context,
      branchid: branchid,
      onqueueFirstKioskDetailLoaded: (loadedQueueFirstKioskDetail) {
        if (mounted) {
          setState(() {
            QueueFirstKioskDetail = loadedQueueFirstKioskDetail;
            isLoading = false;
          });
        }
      },
    );
  }

  Future<void> fetchQueueCountFirstKioskDetail(String branchid) async {
    await ClassTicket.QueueCountFirstticketkioskdetail(
      context: context,
      branchid: branchid,
      onqueuecountFirstKioskDetailLoaded: (loadedQueueCountFirstKioskDetail) {
        if (mounted) {
          setState(() {
            QueueCountFirstKioskDetail = loadedQueueCountFirstKioskDetail;
            isLoading = false;
          });
        }
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
      return '$differenceInMinutes น.';
    } else {
      int hours = differenceInMinutes ~/ 60;
      int remainingMinutes = differenceInMinutes % 60;
      return '$hours:$remainingMinutes';
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
    // _textPaxontroller.dispose();
    // ClassQueue.dispose();
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
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: ClassQueue.callerQueueAllStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
              // } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //   return Center(child: Text('No data available'));
            } else {
              List<Map<String, dynamic>> queueAlll = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: widget.TicketKioskDetail.length,
                itemBuilder: (BuildContext context, int index) {
                  final T1 = widget.TicketKioskDetail[index];
                  final TQ = QueueFirstKioskDetail;
                  final TC = QueueCountFirstKioskDetail;
                  final T2 = QueueAll;
                  List<Widget> queueWidgets = [];
                  // ถ้า T2 ว่างเปล่า ให้แสดงเฉพาะ T1
                  if (T2 == null || T2.isEmpty) {
                    // final linkedQueue = queueAlll
                    //     .where((queue) =>
                    //         queue['branch_service_group_id'] ==
                    //         T1['branch_service_group_id'])
                    //     .toList();

                    final linkedQueueFirst = TQ
                        .where((queue) =>
                            queue['branch_service_group_id'] ==
                            T1['branch_service_group_id'])
                        .toList();

                    final linkedQueueCountFirst = TC
                        .where((queue) =>
                            queue['branch_service_group_id'] ==
                            T1['branch_service_group_id'])
                        .toList();

                    final int length = linkedQueueCountFirst.length;

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
                          side: const BorderSide(
                              color: Colors.white), // สีขอบปุ่ม
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // ลดความโค้งของปุ่มลง
                          ),
                          alignment:
                              Alignment.centerLeft, // จัดข้อความไปทางซ้าย
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
                                      const Text(
                                        'Service',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(9, 159, 175, 1.0),
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      Text(
                                        '${widget.TicketKioskDetail[index]['service_group_name']}',
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                9, 159, 175, 1.0),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${widget.TicketKioskDetail[index]['t_kiosk_btn_name']}',
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(9, 159, 175, 1.0),
                                          fontSize: 15.0,
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
                                      const Text(
                                        'คิวรอ',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(9, 159, 175, 1.0),
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Text(
                                        length
                                            .toString(), // ใช้ toString() เพื่อแปลงเป็นข้อความ
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(9, 159, 175, 1.0),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Text(
                                      //   '',
                                      //   style: TextStyle(
                                      //     color: Color.fromRGBO(9, 159, 175, 1.0),
                                      //     fontSize: 20.0,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'คิวถัดไป',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(9, 159, 175, 1.0),
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Text(
                                        // '',
                                        '${linkedQueueFirst.isNotEmpty ? '${linkedQueueFirst[0]['queue_no']} (${linkedQueueFirst[0]['number_pax']})' : ''}',
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                9, 159, 175, 1.0),
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // Text(
                                      //   '',
                                      //   style: TextStyle(
                                      //     color: Color.fromRGBO(9, 159, 175, 1.0),
                                      //     fontSize: 20.0,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
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
                                          hintStyle: const TextStyle(
                                            color: Color.fromRGBO(
                                                9, 159, 175, 1.0),
                                            fontSize: 35.0,
                                          ),
                                          contentPadding: const EdgeInsets
                                              .symmetric(
                                              vertical:
                                                  10.0), // ลดความสูงของ input
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0), // ทำขอบโค้งมน
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
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
                                          color:
                                              Color.fromRGBO(9, 159, 175, 1.0),
                                          fontSize: 35.0,
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
                                        backgroundColor: const Color.fromRGBO(9,
                                            159, 175, 1.0), // สีข้อความของปุ่ม
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
                                        'เพิ่มคิว',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
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
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255,
                                                    117,
                                                    117,
                                                    117), // สีข้อความของปุ่ม
                                            padding: const EdgeInsets.symmetric(
                                                vertical:
                                                    10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // ความโค้งมนของปุ่ม
                                            ),
                                          ),
                                          child: const Text(
                                            'พักคิว',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              5.0), // เพิ่มช่องว่างระหว่างปุ่ม
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // เพิ่มการทำงานของปุ่ม End
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255,
                                                    117,
                                                    117,
                                                    117), // สีข้อความของปุ่ม
                                            padding: const EdgeInsets.symmetric(
                                                vertical:
                                                    10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // ความโค้งมนของปุ่ม
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
                                      const SizedBox(
                                          width:
                                              5.0), // เพิ่มช่องว่างระหว่างปุ่ม
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _isButtonDisabled
                                              ? null
                                              : () async {
                                                  setState(() {
                                                    _isButtonDisabled = true;
                                                  });

                                                  await ClassQueue()
                                                      .CallerQueue(
                                                    context: context,
                                                    TicketKioskDetail: widget
                                                            .TicketKioskDetail[
                                                        index],
                                                    Branch: widget.Branch,
                                                    Kiosk: widget.Kiosk,
                                                    onCallerLoaded:
                                                        (loadedSearchQueue) {
                                                      setState(() {
                                                        CallerList =
                                                            loadedSearchQueue;
                                                      });
                                                    },
                                                  );

                                                  // await fetchCallerQueueAll(
                                                  //     widget.Branch[
                                                  //         'branch_id']);
                                                  //
                                                  // await fetchQueueFirstKioskDetail(
                                                  //     widget.Branch[
                                                  //         'branch_id']);
                                                  //
                                                  // await fetchQueueCountFirstKioskDetail(
                                                  //     widget.Branch[
                                                  //         'branch_id']);

                                                  setState(() {
                                                    _isButtonDisabled = false;
                                                  });

                                                  Timer(Duration(seconds: 2),
                                                      () {
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    9, 159, 175, 1.0),
                                            padding: const EdgeInsets.symmetric(
                                                vertical:
                                                    10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // ความโค้งมนของปุ่ม
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
                          ],
                        ),
                      ),
                    );
                  } else {
                    // กรอง T2 เพื่อหาข้อมูลที่ตรงกับ T1
                    final linkedQueue = queueAlll
                        .where((queue) =>
                            queue['branch_service_group_id'] ==
                            T1['branch_service_group_id'])
                        .toList();

                    final linkedQueueFirst = TQ
                        .where((queue) =>
                            queue['branch_service_group_id'] ==
                            T1['branch_service_group_id'])
                        .toList();

                    final linkedQueueCountFirst = TC
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
                            side: const BorderSide(
                                color: Colors.white), // สีขอบปุ่ม
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // ลดความโค้งของปุ่มลง
                            ),
                            alignment:
                                Alignment.centerLeft, // จัดข้อความไปทางซ้าย
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0), // เพิ่ม padding
                          ),
                          // child: Text('No data available in QueueAll')),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Service',
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                9, 159, 175, 1.0),
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        Text(
                                          '${widget.TicketKioskDetail[index]['service_group_name']}',
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${widget.TicketKioskDetail[index]['t_kiosk_btn_name']}',
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                                9, 159, 175, 1.0),
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // คอลัมที่ 2
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'คิวรอ',
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                9, 159, 175, 1.0),
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        Text(
                                          '${linkedQueueCountFirst.length}',
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                                9, 159, 175, 1.0),
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Text(
                                        //   '',
                                        //   style: TextStyle(
                                        //     color: Color.fromRGBO(9, 159, 175, 1.0),
                                        //     fontSize: 20.0,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'คิวถัดไป',
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                9, 159, 175, 1.0),
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        Text(
                                          '${linkedQueueFirst.isNotEmpty ? '${linkedQueueFirst[0]['queue_no']} (${linkedQueueFirst[0]['number_pax']})' : ''}',
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                                9, 159, 175, 1.0),
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Text(
                                        //   '',
                                        //   style: TextStyle(
                                        //     color: Color.fromRGBO(9, 159, 175, 1.0),
                                        //     fontSize: 20.0,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // คอลัมที่ 3
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextField(
                                          readOnly: true,
                                          textAlign: TextAlign
                                              .center, // จัดข้อความให้อยู่ตรงกลาง
                                          decoration: InputDecoration(
                                            hintText: '',
                                            hintStyle: const TextStyle(
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontSize: 35.0,
                                            ),
                                            contentPadding: const EdgeInsets
                                                .symmetric(
                                                vertical:
                                                    10.0), // ลดความสูงของ input
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // ทำขอบโค้งมน
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color.fromRGBO(
                                                    9, 159, 175, 1.0),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color.fromRGBO(
                                                    9,
                                                    159,
                                                    175,
                                                    1.0), // สีขอบเมื่อ focus
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                                9, 159, 175, 1.0),
                                            fontSize: 35.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // แถวล่าง
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                              9,
                                              159,
                                              175,
                                              1.0), // สีข้อความของปุ่ม
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
                                          'เพิ่มคิว',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
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
                                                  const Color.fromARGB(
                                                      255, 117, 117, 117),
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical:
                                                      10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0), // ความโค้งมนของปุ่ม
                                              ),
                                            ),
                                            child: const Text(
                                              'พักคิว',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                            width:
                                                5.0), // เพิ่มช่องว่างระหว่างปุ่ม
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // เพิ่มการทำงานของปุ่ม End
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 117, 117, 117),
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical:
                                                      10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0), // ความโค้งมนของปุ่ม
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
                                        const SizedBox(
                                            width:
                                                5.0), // เพิ่มช่องว่างระหว่างปุ่ม
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _isButtonDisabled
                                                ? null
                                                : () async {
                                                    setState(() {
                                                      _isButtonDisabled = true;
                                                    });

                                                    await ClassQueue()
                                                        .CallerQueue(
                                                      context: context,
                                                      TicketKioskDetail: widget
                                                              .TicketKioskDetail[
                                                          index],
                                                      Branch: widget.Branch,
                                                      Kiosk: widget.Kiosk,
                                                      onCallerLoaded:
                                                          (loadedSearchQueue) {
                                                        setState(() {
                                                          CallerList =
                                                              loadedSearchQueue;
                                                        });
                                                      },
                                                    );

                                                    // await fetchCallerQueueAll(
                                                    //     widget.Branch[
                                                    //         'branch_id']);
                                                    //
                                                    // await fetchQueueFirstKioskDetail(
                                                    //     widget.Branch[
                                                    //         'branch_id']);
                                                    //
                                                    // await fetchQueueCountFirstKioskDetail(
                                                    //     widget.Branch[
                                                    //         'branch_id']);

                                                    setState(() {
                                                      _isButtonDisabled = false;
                                                    });

                                                    Timer(Duration(seconds: 2),
                                                        () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      9, 159, 175, 1.0),
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical:
                                                      10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0), // ความโค้งมนของปุ่ม
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
                              backgroundColor:
                                  Colors.white, // สีข้อความและไอคอน
                              minimumSize: Size(
                                  double.infinity,
                                  MediaQuery.of(context).size.height *
                                      0.2), // ขนาดปุ่มให้เต็มแนวขวางและสูง 20% ของหน้าจอ
                              side:
                                  BorderSide(color: Colors.white), // สีขอบปุ่ม
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // ลดความโค้งของปุ่มลง
                              ),
                              alignment:
                                  Alignment.centerLeft, // จัดข้อความไปทางซ้าย
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0), // เพิ่ม padding
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // แถวบน
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Service',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          Text(
                                            '${widget.TicketKioskDetail[index]['service_group_name']}',
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    9, 159, 175, 1.0),
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${widget.TicketKioskDetail[index]['t_kiosk_btn_name']}',
                                            style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // คอลัมที่ 2
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'คิวรอ',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontSize: 20.0,
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
                                            style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontSize: 20.0,
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
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'คิวถัดไป',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          Text(
                                            '${queue['q_n'] != 0 && queue['number_pax_count'] != 0 ? '${queue['q_n']}(${queue['number_pax_count']})' : ''}',
                                            style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // คอลัมที่ 3
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextField(
                                            readOnly: true,
                                            textAlign: TextAlign
                                                .center, // จัดข้อความให้อยู่ตรงกลาง
                                            decoration: InputDecoration(
                                              hintText: '${queue['queue_no']}',
                                              hintStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    9, 159, 175, 1.0),
                                                fontSize: 40.0,
                                              ),
                                              contentPadding: const EdgeInsets
                                                  .symmetric(
                                                  vertical:
                                                      2.0), // ลดความสูงของ input
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0), // ทำขอบโค้งมน
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      9, 159, 175, 1.0),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      9,
                                                      159,
                                                      175,
                                                      1.0), // สีขอบเมื่อ focus
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  9, 159, 175, 1.0),
                                              fontSize: 35.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // แถวล่าง
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // คอลัมที่ 1
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _showNumpadDialog(
                                                context,
                                                widget
                                                    .TicketKioskDetail[index]);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    9,
                                                    159,
                                                    175,
                                                    1.0), // สีข้อความของปุ่ม
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal:
                                                    20.0), // ปรับ margin ด้านในปุ่ม
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // ความโค้งมนของปุ่ม
                                            ),
                                          ),
                                          child: const Text(
                                            'เพิ่มคิว',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
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
                                              // onPressed: () async {
                                              //   await ClassQueue()
                                              //       .UpdateQueue(
                                              //     context: context,
                                              //     SearchQueue: linkedQueue,
                                              //     StatusQueue: 'Holding',
                                              //     StatusQueueNote: '',
                                              //   );
                                              // },
                                              onPressed: _isButtonDisabled
                                                  ? null
                                                  : () async {
                                                      setState(() {
                                                        _isButtonDisabled =
                                                            true; // Disable the button
                                                      });

                                                      await ClassQueue()
                                                          .UpdateQueue(
                                                        context: context,
                                                        SearchQueue:
                                                            linkedQueue,
                                                        StatusQueue: 'Holding',
                                                        StatusQueueNote: '',
                                                      );

                                                      // await fetchCallerQueueAll(
                                                      //     widget.Branch[
                                                      //         'branch_id']);
                                                      //
                                                      // await fetchQueueFirstKioskDetail(
                                                      //     widget.Branch[
                                                      //         'branch_id']);
                                                      //
                                                      // await fetchQueueCountFirstKioskDetail(
                                                      //     widget.Branch[
                                                      //         'branch_id']);

                                                      setState(() {
                                                        _isButtonDisabled =
                                                            false; // Re-enable the button
                                                      });
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        249,
                                                        162,
                                                        31,
                                                        1), // สีข้อความของปุ่ม
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    vertical:
                                                        10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // ความโค้งมนของปุ่ม
                                                ),
                                              ),
                                              child: const Text(
                                                'พักคิว',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                              width:
                                                  5.0), // เพิ่มช่องว่างระหว่างปุ่ม
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: _isButtonDisabled
                                                  ? null
                                                  : () async {
                                                      setState(() {
                                                        _isButtonDisabled =
                                                            true;
                                                      });

                                                      _showSaveDialog(
                                                          context, linkedQueue);

                                                      setState(() {
                                                        _isButtonDisabled =
                                                            false;
                                                      });
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Color.fromARGB(
                                                    255, 255, 0, 0),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
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
                                          const SizedBox(
                                              width:
                                                  5.0), // เพิ่มช่องว่างระหว่างปุ่ม
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: _isButtonDisabled
                                                  ? null
                                                  : () async {
                                                      setState(() {
                                                        _isButtonDisabled =
                                                            true;
                                                      });

                                                      await ClassQueue()
                                                          .UpdateQueue(
                                                        context: context,
                                                        SearchQueue:
                                                            linkedQueue,
                                                        StatusQueue:
                                                            'Recalling',
                                                        StatusQueueNote:
                                                            Reason[index]
                                                                ['reason_id'],
                                                      );

                                                      // await fetchCallerQueueAll(
                                                      //     widget.Branch[
                                                      //         'branch_id']);
                                                      //
                                                      // await fetchQueueFirstKioskDetail(
                                                      //     widget.Branch[
                                                      //         'branch_id']);
                                                      //
                                                      // await fetchQueueCountFirstKioskDetail(
                                                      //     widget.Branch[
                                                      //         'branch_id']);

                                                      setState(() {
                                                        _isButtonDisabled =
                                                            false;
                                                      });
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        9, 159, 175, 1.0),
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    vertical:
                                                        10.0), // ลด padding เพื่อปรับความสูงของปุ่ม
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // ความโค้งมนของปุ่ม
                                                ),
                                              ),
                                              child: const Text(
                                                'เรียกซ้ำ',
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
              );
            }
          },
        ),
      ),
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
            padding: const EdgeInsets.all(20.0), // เพิ่ม padding รอบๆ
            child: Column(
              mainAxisSize: MainAxisSize.min, // ปรับขนาดของ Column ตามเนื้อหา
              children: [
                const Center(
                  child: Text(
                    'บันทึกสิ้นสุดรายการ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(9, 159, 175, 1.0),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 20), // เพิ่มระยะห่างระหว่าง title และเนื้อหา
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

                                  // await fetchCallerQueueAll(
                                  //     widget.Branch['branch_id']);
                                  //
                                  // await fetchQueueFirstKioskDetail(
                                  //     widget.Branch['branch_id']);
                                  //
                                  // await fetchQueueCountFirstKioskDetail(
                                  //     widget.Branch['branch_id']);

                                  await Future.delayed(
                                      const Duration(seconds: 1));

                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      const Color.fromRGBO(9, 159, 175, 1.0),
                                  minimumSize: Size(
                                      screenWidth * 0.8, screenHeight * 0.1),
                                  shape: const RoundedRectangleBorder(),
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

                                  // await fetchCallerQueueAll(
                                  //     widget.Branch['branch_id']);
                                  //
                                  // await fetchQueueFirstKioskDetail(
                                  //     widget.Branch['branch_id']);
                                  //
                                  // await fetchQueueCountFirstKioskDetail(
                                  //     widget.Branch['branch_id']);

                                  await Future.delayed(
                                      const Duration(seconds: 1));

                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      const Color.fromARGB(255, 219, 118, 2),
                                  minimumSize: Size(
                                      screenWidth * 0.8, screenHeight * 0.1),
                                  shape: const RoundedRectangleBorder(),
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
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                    minimumSize: Size(screenWidth * 0.8, screenHeight * 0.1),
                    shape: const RoundedRectangleBorder(),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ปิดหน้าต่าง',
                        style: TextStyle(
                          color: const Color.fromRGBO(255, 255, 255, 1),
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

  void _showNumpadDialog(
      BuildContext context, Map<String, dynamic> TicketKioskDetail) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

        double paddingValue = screenWidth * 0.03; // ลดขนาด padding
        double textFieldHeight =
            screenHeight * 0.06; // ลดขนาด height ของ TextField
        double buttonSize =
            (screenWidth - paddingValue * 8) / 3; // ปรับขนาดปุ่ม
        double fontSize = buttonSize * 0.25; // ลดขนาด fontSize

        TextEditingController _textPaxController = TextEditingController();

        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "ระบุจำนวนลูกค้า",
                          style: TextStyle(
                            fontSize: fontSize * 0.8,
                            color: const Color.fromRGBO(9, 159, 175, 1.0),
                          ),
                        ),
                        SizedBox(width: paddingValue),
                        Expanded(
                          child: Container(
                            height: textFieldHeight,
                            padding: EdgeInsets.symmetric(
                                horizontal: paddingValue * 0.5), // ลด padding
                            child: TextField(
                              controller: _textPaxController,
                              readOnly: true,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: '',
                                hintStyle: TextStyle(
                                  color: const Color.fromRGBO(9, 159, 175, 1.0),
                                  fontSize: fontSize *
                                      0.8, // ลดขนาด fontSize ของ hint
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: paddingValue * 0.5), // ลด padding
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      paddingValue *
                                          1.5), // ลดขนาด borderRadius
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      paddingValue *
                                          1.5), // ลดขนาด borderRadius
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(9, 159, 175, 1.0),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      paddingValue *
                                          1.5), // ลดขนาด borderRadius
                                ),
                              ),
                              style: TextStyle(
                                  color: const Color.fromRGBO(9, 159, 175, 1.0),
                                  fontSize: fontSize * 1.0), // ลดขนาด fontSize
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
                            fontSize: fontSize * 0.8,
                            color: const Color.fromRGBO(9, 159, 175, 1.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: paddingValue * 0.5), // ลดขนาดขนาดของ SizedBox
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: paddingValue * 0.3, // ลดขนาด spacing
                          crossAxisSpacing:
                              paddingValue * 0.3, // ลดขนาด spacing
                        ),
                        itemCount: 12,
                        itemBuilder: (BuildContext context, int index) {
                          String buttonText;
                          Color buttonColor;
                          if (index < 9) {
                            buttonText = '${index + 1}';
                            buttonColor =
                                const Color.fromRGBO(9, 159, 175, 1.0);
                          } else if (index == 9) {
                            buttonText = '';
                            buttonColor = Colors.transparent;
                          } else if (index == 10) {
                            buttonText = '0';
                            buttonColor =
                                const Color.fromRGBO(9, 159, 175, 1.0);
                          } else {
                            buttonText = 'ลบ';
                            buttonColor =
                                const Color.fromRGBO(9, 159, 175, 1.0);
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
                              padding: EdgeInsets.all(
                                  paddingValue * 0.5), // ลดขนาด padding
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(paddingValue),
                              ),
                            ),
                            child: buttonText.isEmpty
                                ? const SizedBox.shrink()
                                : Text(
                                    buttonText,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: buttonText == 'ลบ'
                                          ? fontSize * 0.8 // ลดขนาด fontSize
                                          : fontSize,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                        height: paddingValue * 0.5), // ลดขนาดขนาดของ SizedBox
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
                              backgroundColor:
                                  const Color.fromRGBO(255, 0, 0, 1),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0), // ลดขนาด padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // ลดขนาด borderRadius
                              ),
                            ),
                            child: Text(
                              'ยกเลิก',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize * 0.8, // ลดขนาด fontSize
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
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
                                          fontSize: screenWidth *
                                              0.05, // ลดขนาด fontSize
                                          color: const Color.fromRGBO(
                                              9, 159, 175, 1.0),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                    Timer(const Duration(seconds: 2), () {
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
                                    return const Dialog(
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

                                // await fetchCallerQueueAll(
                                //     widget.Branch['branch_id']);
                                //
                                // await fetchQueueFirstKioskDetail(
                                //     widget.Branch['branch_id']);
                                //
                                // await fetchQueueCountFirstKioskDetail(
                                //     widget.Branch['branch_id']);

                                _textPaxController.text = '';
                                _isLoading = true;
                                _isLoading = false;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromRGBO(9, 159, 175, 1.0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0), // ลดขนาด padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // ลดขนาด borderRadius
                              ),
                            ),
                            child: Text(
                              'บันทึกคิว',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize * 0.8, // ลดขนาด fontSize
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
