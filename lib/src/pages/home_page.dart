import 'package:flutter/material.dart';
import 'package:tatua/src/pages/break_down.dart';
import 'package:tatua/src/pages/draw.dart';
import 'package:tatua/src/pages/run_down.dart';
import 'package:tatua/src/values/strings.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            APP_NAME,
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.search)),
              Tab(icon: Icon(Icons.apps)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            DrawsPage(),
            RundownPage(),
            BreakDownPage(),
          ],
        ),
      ),
    );
  }
}
