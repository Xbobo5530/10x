import 'package:flutter/material.dart';
import 'package:tatua/models/result.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultItemView extends StatelessWidget {
  final Result result;
  ResultItemView(this.result);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          child: new ListTile(
            title: Text('Page ${result.pageNumber}'),
            subtitle: Text(
              '${result.date}',
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
