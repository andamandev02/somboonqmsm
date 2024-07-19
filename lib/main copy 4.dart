// // import 'package:flutter/material.dart';
// // import 'package:socket_io_client/socket_io_client.dart' as IO;
// // import 'package:somboonqms/url_api.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter WebSocket Demo',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: MyHomePage(),
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   String connectionStatus = "Disconnected";
// //   late IO.Socket socket;

// //   @override
// //   void initState() {
// //     super.initState();
// //     initSocket();
// //   }

// //   void initSocket() {
// //     socket = IO.io(
// //         SOCKET_IO_HOST,
// //         IO.OptionBuilder()
// //             .setTransports(['websocket'])
// //             .setPath(SOCKET_IO_PATH)
// //             .setExtraHeaders({'Connection': 'upgrade', 'Upgrade': 'websocket'})
// //             .enableForceNew()
// //             .build());

// //     socket.onConnect((_) {
// //       print('Connection established');
// //       setState(() {
// //         connectionStatus = "Connected";
// //       });
// //     });

// //     socket.onDisconnect((_) {
// //       print('Connection Disconnected');
// //       setState(() {
// //         connectionStatus = "Disconnected";
// //       });
// //     });

// //     socket.onConnectError((err) {
// //       print('Connect Error: $err');
// //       setState(() {
// //         connectionStatus = "Connection Error: $err";
// //       });
// //     });

// //     socket.onError((err) {
// //       print('Error: $err');
// //       setState(() {
// //         connectionStatus = "Error: $err";
// //       });
// //     });

// //     socket.connect();
// //   }

// //   @override
// //   void dispose() {
// //     socket.disconnect();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Flutter WebSocket Demo'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             ElevatedButton(
// //               onPressed: () {
// //                 if (socket.disconnected) {
// //                   initSocket();
// //                 }
// //               },
// //               child: Text("เชื่อมต่อ socket"),
// //             ),
// //             SizedBox(height: 20),
// //             Text(
// //               'WebSocket connection status:',
// //             ),
// //             Text(
// //               connectionStatus,
// //               style: TextStyle(
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:somboonqms/domain.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// void main() async {
//   await Hive.initFlutter();
//   await Hive.openBox('DomainUrl');
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme:
//             ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
//         useMaterial3: true,
//       ),
//       home: const ApplicationDomainScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebSocket Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String connectionStatus = "Disconnected";
  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    IO.Socket socket = IO.io(
      'https://somboonqms.andamandev.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setPath('/nodesomboonqms/socket.io')
          .setExtraHeaders({'Connection': 'upgrade', 'Upgrade': 'websocket'})
          .enableForceNew()
          .build(),
    );

    socket.onConnect((_) {
      print('Connection established');
      setState(() {
        connectionStatus = "Connected";
      });
    });

    socket.onDisconnect((_) {
      print('Connection Disconnected');
      setState(() {
        connectionStatus = "Disconnected";
      });
    });

    socket.onConnectError((err) {
      print('Connect Error: $err');
      setState(() {
        connectionStatus = "Connection Error: $err";
      });
    });

    socket.onError((err) {
      print('Error: $err');
      setState(() {
        connectionStatus = "Error: $err";
      });
    });

    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter WebSocket Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: initSocket,
              child: Text("เชื่อมต่อ socket"),
            ),
            SizedBox(height: 20),
            Text(
              'WebSocket connection status:',
            ),
            Text(
              connectionStatus,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
