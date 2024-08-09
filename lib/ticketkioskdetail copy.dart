// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:somboonqms/Tabs/all.dart';
// import 'package:somboonqms/Tabs/calling.dart';
// import 'package:somboonqms/Tabs/holding.dart';
// import 'package:somboonqms/Tabs/waiting.dart';
// import 'package:somboonqms/crud/branch/ticketkiosk.dart';
// import 'package:somboonqms/crud/queue/crud.dart';

// class TicketKioskDetailScreen extends StatefulWidget {
//   final Map<String, dynamic> Kiosk;
//   final Map<String, dynamic> Branch;
//   const TicketKioskDetailScreen(
//       {super.key, required this.Kiosk, required this.Branch});
//   @override
//   State<TicketKioskDetailScreen> createState() =>
//       _TicketKioskDetailScreenState();
// }

// class _TicketKioskDetailScreenState extends State<TicketKioskDetailScreen> {
//   int _selectedIndex = 0;
//   late List<Map<String, dynamic>> TicketKioskDetail = [];
//   late List<Map<String, dynamic>> SearchQueue = [];
//   bool isLoading = true;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     // เรียกดูรายละเอียดของจุดบัตรคิว
//     fetchTicketKioskDetail(widget.Branch['branch_id']);
//     // _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//     fetchSearchQueue(widget.Branch['branch_id']);
//     // });
//   }

//   Future<void> fetchSearchQueue(String branchid) async {
//     await ClassQueue.searchqueue(
//       context: context,
//       branchid: branchid,
//       onSearchQueueLoaded: (loadedSearchQueue) {
//         if (mounted) {
//           setState(() {
//             SearchQueue = loadedSearchQueue;
//             isLoading = false;
//           });
//         }
//       },
//     );
//   }

//   Future<void> fetchTicketKioskDetail(String branchid) async {
//     await ClassTicket.ticketkioskdetail(
//       context: context,
//       branchid: branchid,
//       onTicketKioskDetailLoaded: (loadedTicketKioskDetail) {
//         if (mounted) {
//           setState(() {
//             TicketKioskDetail = loadedTicketKioskDetail;
//             isLoading = false;
//           });
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // ยกเลิก timer เมื่อ widget ถูก dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/logo/logo.png',
//               height: screenHeight * 0.04,
//             ),
//             const Spacer(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   widget.Branch['branch_name'],
//                   style: TextStyle(
//                       color: Colors.white, fontSize: screenHeight * 0.03),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//         centerTitle: false,
//       ),
//       body: Center(
//         child: DefaultTabController(
//           length: 4,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TabBar(
//                 tabs: [
//                   _buildTab('เรียกคิว', 0),
//                   _buildTab(
//                       'คิวรอ (${SearchQueue.where((item) => item['service_status_id'] == '1').length})',
//                       1),
//                   _buildTab(
//                       'คิวพัก (${SearchQueue.where((item) => item['service_status_id'] == '3').length})',
//                       2),
//                   _buildTab('ทั้งหมด (${SearchQueue.length})', 3),
//                 ],
//                 onTap: (index) {
//                   setState(() {
//                     _selectedIndex = index;
//                   });
//                 },
//               ),
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     TabsCallingScreen(
//                         Branch: widget.Branch,
//                         Kiosk: widget.Kiosk,
//                         TicketKioskDetail: TicketKioskDetail,
//                         SearchQueue: SearchQueue),
//                     TabsWaitingScreen(
//                         SearchQueue: SearchQueue, Branch: widget.Branch),
//                     TabsHoldScreen(
//                         SearchQueue: SearchQueue, Branch: widget.Branch),
//                     TabsAllScreen(
//                         SearchQueue: SearchQueue, Branch: widget.Branch),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTab(String text, int index) {
//     // ดึงขนาดหน้าจอ
//     double screenWidth = MediaQuery.of(context).size.width;
//     double fontSize = screenWidth * 0.030;

//     return Tab(
//       child: Text(
//         text,
//         style: TextStyle(
//           color: _selectedIndex == index ? Colors.white : Colors.white,
//           fontSize: _selectedIndex == index ? fontSize : fontSize,
//           fontWeight:
//               _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//     );
//   }
// }
