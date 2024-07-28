import 'package:flutter/material.dart';

class SomePage extends StatelessWidget {
  final VoidCallback onShowPdf;

  SomePage({required this.onShowPdf});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Some Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: onShowPdf,
          child: Text('Show PDF Dialog'),
        ),
      ),
    );
  }
}
