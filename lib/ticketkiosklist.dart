import 'package:flutter/material.dart';
import 'package:somboonqms/crud/branch/ticketkiosk.dart';
import 'package:somboonqms/load.dart';
import 'package:somboonqms/ticketkioskdetail.dart';

class TicketKioskListScreen extends StatefulWidget {
  final Map<String, dynamic> branch;
  const TicketKioskListScreen({super.key, required this.branch});

  @override
  State<TicketKioskListScreen> createState() => _TicketKioskListScreenState();
}

class _TicketKioskListScreenState extends State<TicketKioskListScreen> {
  late List<Map<String, dynamic>> Kiosk = [];
  bool isLoading = true;

  Future<void> _handleLoading() async {}

  @override
  void initState() {
    super.initState();
    fetchService(widget.branch['branch_id']);
  }

  Future<void> fetchService(String branchid) async {
    await ClassTicket.ticketkiosk(
      context: context,
      branchid: branchid,
      onTicketKioskLoaded: (loadedKiosk) {
        setState(() {
          Kiosk = loadedKiosk;
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
        title: Row(
          children: [
            // Image.asset(
            //   'assets/logo/logo.png',
            //   height: screenHeight * 0.04,
            // ),
            Text(
              'จุดออกบัตรคิว',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenHeight * 0.020,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.branch['branch_name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.020,
                  ),
                ),
              ],
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(20.0),
                //   child: Text(
                //     'จุดออกบัตรคิว',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: screenHeight * 0.03,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Kiosk.isEmpty
                      ? Center(
                          child: Text(
                            'ไม่มีรายการจุดออกบัตรคิว',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.025,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: Kiosk.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  // final result = await Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => LoadingScreen(
                                  //       message: 'กำลังตรวจสอบรายการบริการ',
                                  //       onLoadComplete: _handleLoading,
                                  //       delay: const Duration(
                                  //           seconds: 3), // กำหนดเวลาหน่วงที่นี่
                                  //     ),
                                  //   ),
                                  // );

                                  // if (result == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TicketKioskDetailScreen(
                                              Branch: widget.branch,
                                              Kiosk: Kiosk[index]),
                                    ),
                                  );
                                  // }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  minimumSize:
                                      Size(screenWidth, screenHeight * 0.1),
                                  side: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.branch['branch_name'] +
                                          ' : ' +
                                          (Kiosk[index]['t_kiosk_name'] ?? ''),
                                      style: TextStyle(
                                          color: const Color.fromRGBO(
                                              9, 159, 175, 1.0),
                                          fontSize: screenHeight * 0.03),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward,
                                      size: 35, // กำหนดขนาดไอคอน
                                      color: Color.fromRGBO(9, 159, 175, 1.0),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
