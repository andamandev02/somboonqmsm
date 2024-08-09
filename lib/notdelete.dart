// ********************************* holding *********************************
  // void _showSaveDialog(
  //     BuildContext context, List<Map<String, dynamic>> linkedQueue) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final screenHeight = MediaQuery.of(context).size.height;

  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Container(
  //           width: screenWidth * 0.9, // กำหนดความกว้างของ Dialog
  //           padding: const EdgeInsets.all(20.0), // เพิ่ม padding รอบๆ
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min, // ปรับขนาดของ Column ตามเนื้อหา
  //             children: [
  //               const Center(
  //                 child: Text(
  //                   'บันทึกสิ้นสุดรายการ',
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     color: Color.fromRGBO(9, 159, 175, 1.0),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(
  //                   height: 20), // เพิ่มระยะห่างระหว่าง title และเนื้อหา
  //               Reason.isEmpty
  //                   ? Center(
  //                       child: Text(
  //                         'ไม่มีรายการร้องขอ',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: screenHeight * 0.025,
  //                         ),
  //                       ),
  //                     )
  //                   : Wrap(
  //                       spacing: 10, // ระยะห่างระหว่างปุ่ม
  //                       runSpacing: 10, // ระยะห่างระหว่างแถวของปุ่ม
  //                       children: List.generate(
  //                         Reason.length,
  //                         (index) {
  //                           if (Reason[index]['reason_id'] == '1') {
  //                             return ElevatedButton(
  //                               onPressed: () async {
  //                                 var ReasonNote = '';
  //                                 if (Reason[index]['reason_id'] == '1') {
  //                                   ReasonNote = 'Finishing';
  //                                 } else {
  //                                   ReasonNote = 'Ending';
  //                                 }

  //                                 await ClassQueue().UpdateQueue(
  //                                   context: context,
  //                                   SearchQueue: linkedQueue,
  //                                   StatusQueue: ReasonNote,
  //                                   StatusQueueNote: Reason[index]['reason_id'],
  //                                 );

  //                                 Timer(const Duration(seconds: 2), () {
  //                                   Navigator.of(context).pop();
  //                                 });
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 foregroundColor: Colors.black,
  //                                 backgroundColor:
  //                                     const Color.fromRGBO(9, 159, 175, 1.0),
  //                                 minimumSize: Size(
  //                                     screenWidth * 0.8, screenHeight * 0.1),
  //                                 shape: const RoundedRectangleBorder(),
  //                                 padding: EdgeInsets.symmetric(
  //                                     horizontal: screenWidth * 0.04),
  //                               ),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Text(
  //                                     '${Reason[index]['reson_name']}',
  //                                     style: TextStyle(
  //                                       color: Colors.white,
  //                                       fontSize: screenHeight *
  //                                           0.025, // ปรับขนาดข้อความตามขนาดหน้าจอ
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             );
  //                           } else {
  //                             return ElevatedButton(
  //                               onPressed: () async {
  //                                 var ReasonNote = '';
  //                                 if (Reason[index]['reason_id'] == '1') {
  //                                   ReasonNote = 'Finishing';
  //                                 } else {
  //                                   ReasonNote = 'Ending';
  //                                 }

  //                                 await ClassQueue().UpdateQueue(
  //                                   context: context,
  //                                   SearchQueue: linkedQueue,
  //                                   StatusQueue: ReasonNote,
  //                                   StatusQueueNote: Reason[index]['reason_id'],
  //                                 );

  //                                 Timer(const Duration(seconds: 2), () {
  //                                   Navigator.of(context).pop();
  //                                 });
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 foregroundColor: Colors.black,
  //                                 backgroundColor:
  //                                     const Color.fromARGB(255, 219, 118, 2),
  //                                 minimumSize: Size(
  //                                     screenWidth * 0.8, screenHeight * 0.1),
  //                                 shape: const RoundedRectangleBorder(),
  //                                 padding: EdgeInsets.symmetric(
  //                                     horizontal: screenWidth * 0.04),
  //                               ),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Text(
  //                                     '${Reason[index]['reson_name']}',
  //                                     style: TextStyle(
  //                                       color: Colors.white,
  //                                       fontSize: screenHeight *
  //                                           0.025, // ปรับขนาดข้อความตามขนาดหน้าจอ
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             );
  //                           }
  //                         },
  //                       ),
  //                     ),
  //               const SizedBox(height: 10),
  //               ElevatedButton(
  //                 onPressed: () async {
  //                   Navigator.of(context).pop();
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   foregroundColor: Colors.black,
  //                   backgroundColor: const Color.fromARGB(255, 255, 0, 0),
  //                   minimumSize: Size(screenWidth * 0.8, screenHeight * 0.1),
  //                   shape: RoundedRectangleBorder(),
  //                   padding:
  //                       EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       'ปิดหน้าต่าง',
  //                       style: TextStyle(
  //                         color: Color.fromRGBO(255, 255, 255, 1),
  //                         fontSize: screenHeight *
  //                             0.025, // ปรับขนาดข้อความตามขนาดหน้าจอ
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
// ********************************* holding *********************************


// ********************************* waiting *********************************
//  void _showSaveDialog(
//       BuildContext context, List<Map<String, dynamic>> linkedQueue) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             width: screenWidth * 0.9, // กำหนดความกว้างของ Dialog
//             padding: const EdgeInsets.all(20.0), // เพิ่ม padding รอบๆ
//             child: Column(
//               mainAxisSize: MainAxisSize.min, // ปรับขนาดของ Column ตามเนื้อหา
//               children: [
//                 const Center(
//                   child: Text(
//                     'บันทึกสิ้นสุดรายการ',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Color.fromRGBO(9, 159, 175, 1.0),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                     height: 20), // เพิ่มระยะห่างระหว่าง title และเนื้อหา
//                 Reason.isEmpty
//                     ? Center(
//                         child: Text(
//                           'ไม่มีรายการร้องขอ',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: screenHeight * 0.025,
//                           ),
//                         ),
//                       )
//                     : Wrap(
//                         spacing: 10, // ระยะห่างระหว่างปุ่ม
//                         runSpacing: 10, // ระยะห่างระหว่างแถวของปุ่ม
//                         children: List.generate(
//                           Reason.length,
//                           (index) {
//                             if (Reason[index]['reason_id'] == '1') {
//                               return ElevatedButton(
//                                 onPressed: () async {
//                                   // ignore: non_constant_identifier_names
//                                   var ReasonNote = '';
//                                   if (Reason[index]['reason_id'] == '1') {
//                                     ReasonNote = 'Finishing';
//                                   } else {
//                                     ReasonNote = 'Ending';
//                                   }

//                                   await ClassQueue().UpdateQueue(
//                                     context: context,
//                                     SearchQueue: linkedQueue,
//                                     StatusQueue: ReasonNote,
//                                     StatusQueueNote: Reason[index]['reason_id'],
//                                   );

//                                   Timer(const Duration(seconds: 2), () {
//                                     Navigator.of(context).pop();
//                                     // Navigator.of(context).pop();
//                                   });
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   foregroundColor: Colors.black,
//                                   backgroundColor:
//                                       const Color.fromRGBO(9, 159, 175, 1.0),
//                                   minimumSize: Size(
//                                       screenWidth * 0.8, screenHeight * 0.1),
//                                   shape: const RoundedRectangleBorder(),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: screenWidth * 0.04),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       '${Reason[index]['reson_name']}',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: screenHeight *
//                                             0.025, // ปรับขนาดข้อความตามขนาดหน้าจอ
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             } else {
//                               return ElevatedButton(
//                                 onPressed: () async {
//                                   // ignore: non_constant_identifier_names
//                                   var ReasonNote = '';
//                                   if (Reason[index]['reason_id'] == '1') {
//                                     ReasonNote = 'Finishing';
//                                   } else {
//                                     ReasonNote = 'Ending';
//                                   }

//                                   await ClassQueue().UpdateQueue(
//                                     context: context,
//                                     SearchQueue: linkedQueue,
//                                     StatusQueue: ReasonNote,
//                                     StatusQueueNote: Reason[index]['reason_id'],
//                                   );

//                                   Timer(const Duration(seconds: 2), () {
//                                     Navigator.of(context).pop();
//                                     // Navigator.of(context).pop();
//                                   });
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   foregroundColor: Colors.black,
//                                   backgroundColor:
//                                       const Color.fromARGB(255, 219, 118, 2),
//                                   minimumSize: Size(
//                                       screenWidth * 0.8, screenHeight * 0.1),
//                                   shape: const RoundedRectangleBorder(),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: screenWidth * 0.04),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       '${Reason[index]['reson_name']}',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: screenHeight *
//                                             0.025, // ปรับขนาดข้อความตามขนาดหน้าจอ
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                       ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () async {
//                     Navigator.of(context).pop();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.black,
//                     backgroundColor: const Color.fromARGB(255, 255, 0, 0),
//                     minimumSize: Size(screenWidth * 0.8, screenHeight * 0.1),
//                     shape: const RoundedRectangleBorder(),
//                     padding:
//                         EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'ปิดหน้าต่าง',
//                         style: TextStyle(
//                           color: const Color.fromRGBO(255, 255, 255, 1),
//                           fontSize: screenHeight *
//                               0.025, // ปรับขนาดข้อความตามขนาดหน้าจอ
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// ********************************* waiting *********************************
