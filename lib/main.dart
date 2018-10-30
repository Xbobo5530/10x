import 'package:flutter/material.dart';
import 'package:tatua/pages/draw.dart';
import 'package:tatua/values/strings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: DrawsPage(),
    );
  }
}
