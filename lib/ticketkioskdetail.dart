import 'dart:async';
import 'package:flutter/material.dart';
import 'package:somboonqms/Tabs/all.dart';
import 'package:somboonqms/Tabs/calling.dart';
import 'package:somboonqms/Tabs/holding.dart';
import 'package:somboonqms/Tabs/waiting.dart';
import 'package:somboonqms/crud/branch/ticketkiosk.dart';
import 'package:somboonqms/crud/queue/crud.dart';

class TicketKioskDetailScreen extends StatefulWidget {
  final Map<String, dynamic> Kiosk;
  final Map<String, dynamic> Branch;
  const TicketKioskDetailScreen(
      {super.key, required this.Kiosk, required this.Branch});
  @override
  State<TicketKioskDetailScreen> createState() =>
      _TicketKioskDetailScreenState();
}

class _TicketKioskDetailScreenState extends State<TicketKioskDetailScreen> {
  int _selectedIndex = 0;
  late List<Map<String, dynamic>> TicketKioskDetail = [];
  late List<Map<String, dynamic>> SearchQueue = [];

  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // เรียกดูรายละเอียดของจุดบัตรคิว
    fetchTicketKioskDetail(widget.Branch['branch_id']);
    // รันรายการคิวตลอด
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchSearchQueue(widget.Branch['branch_id']);
    });
  }

  Future<void> fetchSearchQueue(String branchid) async {
    await ClassQueue.searchqueue(
      context: context,
      branchid: branchid,
      onSearchQueueLoaded: (loadedSearchQueue) {
        if (mounted) {
          setState(() {
            SearchQueue = loadedSearchQueue;
            isLoading = false;
          });
        }
      },
    );
  }

  Future<void> fetchTicketKioskDetail(String branchid) async {
    await ClassTicket.ticketkioskdetail(
      context: context,
      branchid: branchid,
      onTicketKioskDetailLoaded: (loadedTicketKioskDetail) {
        if (mounted) {
          setState(() {
            TicketKioskDetail = loadedTicketKioskDetail;
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // ยกเลิก timer เมื่อ widget ถูก dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
        title: Row(
          children: [
            Image.asset(
              'assets/logo/logo.png',
              height: screenHeight * 0.04,
            ),
            const Spacer(), // จัดให้โลโก้อยู่ชิดซ้าย
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.Branch['branch_name'],
                  style: TextStyle(
                      color: Colors.white, fontSize: screenHeight * 0.02),
                ),
                Text(
                  '${widget.Kiosk['t_kiosk_label']}',
                  style: TextStyle(
                      color: Colors.white, fontSize: screenHeight * 0.02),
                ),
              ],
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // ตั้งค่าสีไอคอนย้อนกลับเป็นสีขาว
        ),
        centerTitle: false,
      ),
      body: Center(
        child: DefaultTabController(
          length: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabBar(
                tabs: [
                  _buildTab('Calling', 0),
                  _buildTab(
                      'Wait (${SearchQueue.where((item) => item['service_status_id'] == '1').length})',
                      1),
                  _buildTab(
                      'Hold (${SearchQueue.where((item) => item['service_status_id'] == '3').length})',
                      2),
                  _buildTab('All (${SearchQueue.length})', 3),
                ],
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    TabsCallingScreen(
                        Branch: widget.Branch,
                        Kiosk: widget.Kiosk,
                        TicketKioskDetail: TicketKioskDetail,
                        SearchQueue: SearchQueue),
                    TabsWaitingScreen(
                      SearchQueue: SearchQueue,
                    ),
                    TabsHoldScreen(
                      SearchQueue: SearchQueue,
                    ),
                    TabsAllScreen(
                      SearchQueue: SearchQueue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    return Tab(
      child: Text(
        text,
        style: TextStyle(
          color: _selectedIndex == index
              ? Colors.white
              : Colors.white, // กำหนดสีข้อความของแท็บ
          fontSize:
              _selectedIndex == index ? 15 : 14, // กำหนดขนาดตัวอักษรของแท็บ
          fontWeight: _selectedIndex == index
              ? FontWeight.bold
              : FontWeight.normal, // กำหนดความหนาของตัวอักษรของแท็บ
        ),
      ),
    );
  }
}
