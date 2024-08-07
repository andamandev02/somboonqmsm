import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:somboonqms/branchlist.dart';
import 'package:somboonqms/connect/setthing.dart';
import 'package:somboonqms/load.dart';
import 'package:somboonqms/printing.dart';
import 'package:somboonqms/url_api.dart';

class ApplicationDomainScreen extends StatefulWidget {
  const ApplicationDomainScreen({super.key});
  // const ApplicationDomainScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationDomainScreen> createState() =>
      _ApplicationDomainScreenState();
}

class _ApplicationDomainScreenState extends State<ApplicationDomainScreen> {
  final TextEditingController _textDomainController = TextEditingController();
  late Box _domainBox;

  @override
  void initState() {
    super.initState();
    _initDomainFromHive();
  }

  void _initDomainFromHive() async {
    _domainBox = Hive.box('DomainUrl');
    _textDomainController.text = _domainBox.get('Domain') ?? '';
    apiBaseURL = _textDomainController.text;
    setState(() {});
  }

  Future<void> _handleDomain() async {
    if (_textDomainController.text.isNotEmpty) {
      var domain = _textDomainController.text;
      await _addToHive(domain);
      setState(() {
        apiBaseURL = domain;
      });
    }
  }

  Future<void> _addToHive(String domain) async {
    if (_domainBox.containsKey('Domain')) {
      await _domainBox.delete('Domain');
    }
    await _domainBox.put('Domain', domain);
    setState(() {});
  }

  void _submitClearText() {
    _textDomainController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(9, 159, 175, 1.0),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/logo/logo.png',
              fit: BoxFit.none,
            ),
          ),
          ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.5,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Application Domain",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: _textDomainController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                15.0), // ปรับค่าที่นี่เพื่อให้ขอบโค้งตามต้องการ
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 30.0),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _submitClearText();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(color: Colors.white),
                            ),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'เลคียข้อความ',
                                style: TextStyle(
                                    color: Color.fromRGBO(9, 159, 175, 1.0)),
                              ),
                              SizedBox(width: 8.0),
                              Icon(Icons.clear,
                                  color: Color.fromRGBO(9, 159, 175, 1.0),
                                  size: 24.0),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_textDomainController.text.isNotEmpty) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoadingScreen(
                                    message:
                                        'กำลังตรวจสอบ Domain กรุณารอสักครู๋',
                                    onLoadComplete: _handleDomain,
                                    delay: const Duration(seconds: 3),
                                  ),
                                ),
                              );

                              if (result == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BranchListScreen(),
                                  ),
                                );
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    content: Flexible(
                                      child: Text(
                                        'กรุณาป้อน Domain\nเพื่อเข้าใช้งานระบบ',
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              );

                              Future.delayed(const Duration(seconds: 3), () {
                                Navigator.of(context).pop();
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            backgroundColor:
                                const Color.fromRGBO(9, 159, 175, 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(color: Colors.white),
                            ),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'ต่อไป',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 8.0),
                              Icon(Icons.arrow_forward,
                                  color: Colors.white, size: 24.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.9,
                    //   child: FutureBuilder<Box>(
                    //     future: Hive.openBox('DomainUrl'),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return const CircularProgressIndicator();
                    //       } else if (snapshot.hasError) {
                    //         return Text('Error: ${snapshot.error}');
                    //       } else {
                    //         var box = snapshot.data;
                    //         if (box!.containsKey('Domain')) {
                    //           var domain = box.get('Domain');
                    //           return Text(
                    //             'Domain: $domain',
                    //             textAlign: TextAlign.right,
                    //             style: const TextStyle(color: Colors.white),
                    //           );
                    //         } else {
                    //           return const SizedBox.shrink();
                    //         }
                    //       }
                    //     },
                    //   ),
                    // ),
                    Positioned(
                      bottom: 20,
                      right: 50,
                      child: IconButton(
                        icon:
                            Icon(Icons.settings, color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    // Positioned(
                    //   bottom: 20,
                    //   right: 50,
                    //   child: IconButton(
                    //     icon:
                    //         Icon(Icons.settings, color: Colors.white, size: 30),
                    //     onPressed: () {
                    //       showQRCodeDialog();
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
