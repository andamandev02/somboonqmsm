import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:somboonqms/crud/branch/branchlist.dart';
import 'package:somboonqms/ticketkiosklist.dart';

class BranchListScreen extends StatefulWidget {
  const BranchListScreen({super.key});

  @override
  State<BranchListScreen> createState() => _BranchListScreenState();
}

class _BranchListScreenState extends State<BranchListScreen> {
  // ignore: non_constant_identifier_names
  List<Map<String, dynamic>> Branch = [];

  @override
  void initState() {
    super.initState();
    fetchBranchList();
  }

  Future<void> fetchBranchList() async {
    ClassBranch.branchlist(
      context: context,
      // ignore: non_constant_identifier_names
      onBranchListLoaded: (LoadingBranchList) {
        setState(() {
          Branch = LoadingBranchList;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
        title: const Text(
          'เลือกสาขา',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Branch.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: Branch.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TicketKioskListScreen(branch: Branch[index]),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 80),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 255, 255, 255)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Branch[index]['branch_name'],
                          style: const TextStyle(
                            color: Color.fromRGBO(9, 159, 175, 1.0),
                            fontSize: 20.0,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 35,
                          color: Color.fromRGBO(9, 159, 175, 1.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
