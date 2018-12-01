import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tatua/src/models/main_model.dart';
import 'package:tatua/src/values/strings.dart';

class BreakDownPage extends StatelessWidget {
  final _codeController = TextEditingController();
  final _drawController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _buildField(int length, TextEditingController controller, String hint) =>
        Container(
          padding: const EdgeInsets.all(16.0),
          width: 200.0,
          child: TextField(
            maxLength: length,
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: hint,
            ),
          ),
        );

    _handleCompute(MainModel model) {
      final code = _codeController.text.trim();
      final draw = _drawController.text.trim();
      if (code.isEmpty || draw.isEmpty) {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Fill all fields to compute')));
        return null;
      }

      model.computeBreakdown(code, draw);
    }

    final _fields = Row(
      children: <Widget>[
        _buildField(1, _codeController, codeText),
        _buildField(3, _drawController, drawNumberText),
      ],
    );
    final _computeButton = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ScopedModelDescendant<MainModel>(
              builder: (_, __, model) => RaisedButton(
                    textColor: Colors.white,
                    color: Colors.brown,
                    child: Text(computeText),
                    onPressed: () => _handleCompute(model),
                  ),
            ),
          ),
        ],
      ),
    );
    final _resultsSection = ScopedModelDescendant<MainModel>(
      builder: (_, __, model) => model.breakDownResult == null
          ? Container()
          : Text(
              model.breakDownResult,
              style: TextStyle(
                  color: Colors.brown,
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold),
            ),
    );
    return Column(
      children: <Widget>[
        _fields,
        _computeButton,
        Expanded(child: Center(child: _resultsSection))
      ],
    );
  }
}
