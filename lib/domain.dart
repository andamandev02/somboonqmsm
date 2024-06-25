import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:somboonqms/branchlist.dart';
import 'package:somboonqms/load.dart';
import 'package:somboonqms/url_api.dart';

class ApplicationDomainScreen extends StatefulWidget {
  const ApplicationDomainScreen({Key? key}) : super(key: key);

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
            top: 150,
            left: 0,
            right: 30,
            child: Image.asset(
              'assets/logo/logo.png',
              fit: BoxFit.scaleDown,
            ),
          ),
          ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.4,
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
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: _textDomainController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          filled: true,
                          fillColor: Colors.white,
                        ),
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
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 255, 255, 255)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'CLEAR',
                                style: TextStyle(
                                    color: Color.fromRGBO(9, 159, 175, 1.0)),
                              ),
                              SizedBox(width: 4.0),
                              Icon(Icons.clear,
                                  color: Color.fromRGBO(9, 159, 175, 1.0)),
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
                                    delay: const Duration(
                                        seconds: 3), // กำหนดเวลาหน่วงที่นี่
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
                                        textAlign: TextAlign
                                            .center, // ข้อความจะอยู่ตรงกลาง
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
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(9, 159, 175, 1.0)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'ต่อไป',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 4.0),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: FutureBuilder<Box>(
                        future: Hive.openBox('DomainUrl'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            var box = snapshot.data;
                            if (box!.containsKey('Domain')) {
                              var domain = box.get('Domain');
                              return Text(
                                'Domain: $domain',
                                textAlign: TextAlign.right,
                                style: TextStyle(color: Colors.white),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }
                        },
                      ),
                    ),
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
