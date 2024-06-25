// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:somboonqms/ticketkioskdetail.dart';
// import 'package:somboonqms/url_api.dart';

// class IssuingQueueScreen extends StatefulWidget {
//   final Map<String, dynamic> branch;
//   const IssuingQueueScreen({super.key, required this.branch});

//   @override
//   State<IssuingQueueScreen> createState() => _IssuingQueueScreenState();
// }

// class _IssuingQueueScreenState extends State<IssuingQueueScreen> {
//   late List<Map<String, dynamic>> Service = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchService(widget.branch['branch_id']);
//   }

//   Future<void> fetchService(int branchid) async {
//     try {
//       final queryParameters = {
//         'branchid': branchid.toString(),
//       };
//       final uri = Uri.parse('$branchServiceUrl')
//           .replace(queryParameters: queryParameters);
//       final response = await http.get(
//         uri,
//         headers: <String, String>{
//           HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
//         },
//       );
//       if (response.statusCode == 200) {
//         Map<String, dynamic> jsonData = jsonDecode(response.body);
//         setState(() {
//           Service = (jsonData['data'] as List)
//               .map((item) => item as Map<String, dynamic>)
//               .toList();
//           isLoading = false;
//         });
//         print(Service);
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         print('Failed to load service. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('Error occurred: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/logo/logo.png',
//               height: screenHeight * 0.05,
//             ),
//             const Spacer(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   widget.branch['branch_name'],
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: screenHeight * 0.03,
//                   ),
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
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Text(
//                     'จุดออกบัตรคิว',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: screenHeight * 0.03,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Service.isEmpty
//                       ? Center(
//                           child: Text(
//                             'ไม่มีรายการจุดออกบัตรคิว',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: screenHeight * 0.025,
//                             ),
//                           ),
//                         )
//                       : ListView.builder(
//                           padding: const EdgeInsets.all(20),
//                           itemCount: Service.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Container(
//                               margin: const EdgeInsets.symmetric(vertical: 5.0),
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   // Navigator.push(
//                                   //   context,
//                                   //   MaterialPageRoute(
//                                   //     builder: (context) =>
//                                   //         BranchScreen(service: Service[index]),
//                                   //   ),
//                                   // );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   foregroundColor: Colors.black,
//                                   backgroundColor: Colors.white,
//                                   minimumSize:
//                                       Size(screenWidth, screenHeight * 0.1),
//                                   side: const BorderSide(
//                                       color:
//                                           Color.fromARGB(255, 255, 255, 255)),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   alignment: Alignment.centerLeft,
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: screenWidth * 0.04),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       widget.branch['branch_name'] +
//                                           ' : ' +
//                                           Service[index]['service_name'],
//                                       style: TextStyle(
//                                           color: const Color.fromRGBO(
//                                               9, 159, 175, 1.0),
//                                           fontSize: screenHeight * 0.025),
//                                     ),
//                                     const Icon(
//                                       Icons.arrow_forward,
//                                       size: 35, // กำหนดขนาดไอคอน
//                                       color: Color.fromRGBO(9, 159, 175, 1.0),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
