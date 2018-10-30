import 'package:flutter/material.dart';
import 'package:tatua/values/strings.dart';

class RundownPage extends StatefulWidget {
  @override
  _RundownPageState createState() => _RundownPageState();
}

class _RundownPageState extends State<RundownPage> {
  var _resultsSection = Container();
  var _rundownController = TextEditingController();
  var _drawController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _computeRunDown(String runDown, String draw) {
      var runDownFirstPos = int.parse(runDown[0]);
      var runDownSecondPos = int.parse(runDown[1]);
      var runDownThirdPos = int.parse(runDown[2]);

      var drawFirstPos = int.parse(draw[0]);
      var drawSecondPos = int.parse(draw[1]);
      var drawThirdPos = int.parse(draw[2]);
      print(
          'rFirst: $runDownFirstPos, rSecond: $runDownSecondPos, rThird: $runDownThirdPos\n'
          'dFirst $drawFirstPos, dSecond: $drawSecondPos, dThird: $drawThirdPos');

      var runDownMatrix = List(12);
      runDownMatrix[0] = [runDownFirstPos, runDownSecondPos, runDownThirdPos];
      runDownMatrix[1] = [drawFirstPos, drawSecondPos, drawThirdPos];

      for (var i = 0; i < 12; i++) {
        if (i < 10) {
          runDownMatrix[i + 2] = [
            (runDownMatrix[0][0] + runDownMatrix[i + 1][0]) % 10,
            (runDownMatrix[0][1] + runDownMatrix[i + 1][1]) % 10,
            (runDownMatrix[0][2] + runDownMatrix[i + 1][2]) % 10,
          ];
        }
      }

      print(runDownMatrix);

      setState(() {
        _resultsSection = Container(
            child: Padding(
          padding: const EdgeInsets.only(left: 70.0, right: 70.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 1.0),
              itemCount: 52,
              itemBuilder: ((_, index) {
                var singleList = [];
                var rowCount = 1;
                runDownMatrix.forEach((row) {
                  for (var i = 0; i < row.length; i++) {
                    if (i % 3 == 0) {
                      singleList.add(rowCount);
                      rowCount++;
                    }
                    singleList.add(row[i]);
                  }
                });
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                      child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  index % 4 == 0 ? Colors.black : Colors.brown),
                          child: Center(
                              child: Text(
                            '${singleList[index]}',
                            style: TextStyle(color: Colors.white),
                          )))),
                );
              })),
        ));
      });
    }

    var _runDownResult = Container(
        child: Padding(
      padding: const EdgeInsets.only(left: 70.0, right: 70.0),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 1.0),
          itemCount: 52,
          itemBuilder: ((_, index) {
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
                        '${singleList[index]}',
                        style: TextStyle(color: Colors.white),
                      )))),
            );
          })),
    ));

    _promptEmptyFields() {}
    _checkInputValidity(TextEditingController drawController,
        TextEditingController rundownController) {
      print('at compute rundown');
      var runDown = _rundownController.text.trim();
      var draw = _drawController.text.trim();
      runDown.isNotEmpty && draw.isNotEmpty
          ? _computeRunDown(runDown, draw)
          : _promptEmptyFields();
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

    var _computeButton = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.brown,
                  child: Text(computeRundownText),
                  onPressed: () => _checkInputValidity(
                      _drawController, _rundownController))),
        ],
      ),
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
        Expanded(child: _resultsSection),
      ],
    );
  }
}
