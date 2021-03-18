
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screen/homepage.dart';
import 'package:mobile/screen/test.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final Future<FirebaseApp> _connection = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _connection,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Connection Error');
        }
        else if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: HomePage(),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
