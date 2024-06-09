import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String message = "Welcome to the Home Page!";

  void _updateMessage() {
    setState(() {
      message = "You pressed the button!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateMessage,
              child: Text('Press me'),
            ),
          ],
        ),
      ),
    );
  }
}


