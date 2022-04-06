import 'package:flutter/material.dart';

void main() {
  runApp(main_App());
}

class main_App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('CE就活支援アプリ'),
        ),
          body:Container(
            width: double.infinity,
            child: const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '病院名を検索',
              ),
            ),
          ),
      ),
    );
  }
}
