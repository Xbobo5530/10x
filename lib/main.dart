import 'package:flutter/material.dart';
import 'package:tatua/src/models/main_model.dart';
import 'package:tatua/src/pages/home_page.dart';
import 'package:tatua/src/values/strings.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp(model: MainModel()));

class MyApp extends StatelessWidget {
	final MainModel model;
	MyApp({
		Key key,
		this.model,
	}) : super(key: key);
	@override
	Widget build(BuildContext context) {
		return ScopedModel<MainModel>(
			model: model,
			child: MaterialApp(
				title: APP_NAME,
				theme: ThemeData(
					primarySwatch: Colors.brown,
				),
				home: MyHomePage(),
			),
		);
	}
}
