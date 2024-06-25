import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final Future<void> Function() onLoadComplete;
  final String message;
  final Duration delay;

  const LoadingScreen({
    Key? key,
    required this.onLoadComplete,
    required this.message,
    this.delay = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: onLoadComplete(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Future.delayed(delay, () {
              Navigator.pop(context, true);
            });
          }
          return Center(
            child: BouncingDotsLoader(),
          );
        },
      ),
    );
  }
}

class BouncingDotsLoader extends StatefulWidget {
  const BouncingDotsLoader({Key? key}) : super(key: key);

  @override
  _BouncingDotsLoaderState createState() => _BouncingDotsLoaderState();
}

class _BouncingDotsLoaderState extends State<BouncingDotsLoader>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _controller5;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _controller3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _controller4 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _controller5 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _startAnimation();
  }

  void _startAnimation() {
    _controller1.forward().then((value) {
      _controller1.reverse();
      _controller2.forward().then((value) {
        _controller2.reverse();
        _controller3.forward().then((value) {
          _controller3.reverse();
          _controller4.forward().then((value) {
            _controller4.reverse();
            _controller5.forward().then((value) {
              _controller5.reverse();
              _startAnimation();
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDot(_controller1),
            const SizedBox(width: 8.0),
            _buildDot(_controller2),
            const SizedBox(width: 8.0),
            _buildDot(_controller3),
            const SizedBox(width: 8.0),
            _buildDot(_controller4),
            const SizedBox(width: 8.0),
            _buildDot(_controller5),
          ],
        ),
        const SizedBox(height: 16.0),
        const Text(
          'กำลังตรวจสอบข้อมูล กรุณาโปรดรอสักครู่',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget _buildDot(AnimationController controller) {
    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0).animate(controller),
      child: const Dot(),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  const Dot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 10, 166, 227),
      ),
    );
  }
}
