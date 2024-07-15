import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() async {
  runApp(const StreamSocketApp());
}

class StreamSocketApp extends StatelessWidget {
  const StreamSocketApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: BuildWithSocketStream(),
        ),
      ),
    );
  }
}

class StreamSocket {
  final _socketResponse = StreamController<String>();
  void Function(String) get addResponse => _socketResponse.sink.add;
  Stream<String> get getResponse => _socketResponse.stream;
  void dispose() {
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();

void connectAndListen() {
  IO.Socket socket = IO.io('https://somboonqms.andamandev.com/nodesomboonqms/',
      IO.OptionBuilder().setTransports(['websocket']).build());

  socket.onConnect((_) {
    print('connect');
    socket.emit('msg', 'test');
  });

  socket.on('event', (data) {
    streamSocket.addResponse(data);
    print('Received: $data');
  });

  socket.onDisconnect((_) => print('disconnect'));

  socket.onError((error) {
    print('Error: $error');
  });

  // Connect to the server
  socket.connect();
}

class BuildWithSocketStream extends StatefulWidget {
  const BuildWithSocketStream({Key? key}) : super(key: key);

  @override
  _BuildWithSocketStreamState createState() => _BuildWithSocketStreamState();
}

class _BuildWithSocketStreamState extends State<BuildWithSocketStream> {
  @override
  void initState() {
    super.initState();
    connectAndListen(); // Connect to the socket server on widget initialization
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: streamSocket.getResponse,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Text(snapshot.data!),
            );
          } else {
            return Container(
              child:
                  Text('Waiting for data...'), // Placeholder until data arrives
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    streamSocket.dispose(); // Dispose the stream controller
    super.dispose();
  }
}

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
