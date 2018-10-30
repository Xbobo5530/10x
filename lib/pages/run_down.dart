import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tatua/models/main_model.dart';
import 'package:tatua/values/strings.dart';

//class RundownPage extends StatefulWidget {
//  @override
//  _RundownPageState createState() => _RundownPageState();
//}

class RundownPage extends StatelessWidget {
//  var _resultsSection = Container();
  var _rundownController = TextEditingController();
  var _drawController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _runDownResultSection = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        if (model.rundownSingleList.isEmpty) return Container();
        return Container(
            child: Padding(
          padding: const EdgeInsets.only(left: 70.0, right: 70.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 1.0),
              itemCount: 52,
              itemBuilder: ((_, index) {
                return RundownGridItemView(
                  index: index,
                  rundownItem: model.rundownSingleList[index],
                );
              })),
        ));
      },
    );

    _promptEmptyFields() {}

    _checkInputValidity(MainModel model, TextEditingController drawController,
        TextEditingController rundownController) {
      print('at compute rundown');
      final runDown = _rundownController.text.trim();
      final draw = _drawController.text.trim();
      if (runDown.isEmpty || draw.isEmpty) _promptEmptyFields();
      model.computeRunDown(runDown, draw);
      FocusScope.of(context).requestFocus(FocusNode());
    }

    var _runDownField = Container(
      width: 150.0,
      child: TextField(
        maxLength: 3,
        controller: _rundownController,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          labelText: enterRundownLabelText,
        ),
      ),
    );

    var _drawsField = Container(
      width: 150.0,
      child: TextField(
        maxLength: 3,
        controller: _drawController,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          labelText: drawsText,
        ),
      ),
    );

    var _computeButton = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.brown,
                      child: Text(computeRundownText),
                      onPressed: () => _checkInputValidity(
                          model, _drawController, _rundownController))),
            ],
          ),
        );
      },
    );

    var _fields = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _runDownField,
        _drawsField,
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _fields,
        _computeButton,
        Expanded(child: _runDownResultSection),
      ],
    );
  }
}

class RundownGridItemView extends StatelessWidget {
  final int index;
  final int rundownItem;
  RundownGridItemView({this.index, this.rundownItem});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
          child: Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index % 4 == 0 ? Colors.black : Colors.brown),
              child: Center(
                  child: Text(
                '$rundownItem',
                style: TextStyle(color: Colors.white),
              )))),
    );
  }
}
