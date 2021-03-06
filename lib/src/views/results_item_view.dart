import 'package:flutter/material.dart';
import 'package:tatua/src/models/result.dart';
import 'package:tatua/src/values/consts.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultItemView extends StatelessWidget {
  final Result result;
  ResultItemView({this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          child: ListTile(
            title:
                Text('Page ${result.pageNumber}'),
            subtitle: Text(
              result.lastDraw.length == DRAW_ID_LENGTH 
              ? 'This is the latest draw\n${result.date}'
:              'Previous draw: ${result.lastDraw}\n${result.date}'
              ,
            ),
          ),
          onTap: () => _launchURL(result.url),
        ),
        new Divider(),
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
