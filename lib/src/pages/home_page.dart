import 'package:flutter/material.dart';
import 'package:tatua/src/pages/draw.dart';
import 'package:tatua/src/pages/run_down.dart';
import 'package:tatua/src/values/strings.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            APP_NAME,
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.search)),
              Tab(icon: Icon(Icons.apps)),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            DrawsPage(),
            RundownPage(),
          ],
        ),
      ),
    );
  }
}
