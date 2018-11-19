import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tatua/models/main_model.dart';
import 'package:tatua/values/codes.dart';
import 'package:tatua/values/strings.dart';
import 'package:tatua/views/results_item_view.dart';

const tag = 'DrawsPage:';

class DrawsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _drawController = TextEditingController();

    _startSearch(MainModel model) {
      final draw = _drawController.text.trim();
      if (draw.isNotEmpty) {
        model.search(
          draw,
        );
        _drawController.clear();
        FocusScope.of(context).requestFocus(FocusNode());
      }
    }

    _stopSearch(MainModel model) {
      print('stop search is called');
      model.cancelSearch();
      final snackBar = SnackBar(content: Text(model.searchResultMessage));
      Scaffold.of(context).showSnackBar(snackBar);
    }

    final _drawField = Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        width: 200.0,
        child: TextField(
          maxLength: 3,
          controller: _drawController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.numberWithOptions(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: enterDrawHint,
          ),
        ),
      ),
    );

    final _regionSwitcher =
        ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return Row(children: <Widget>[
        RadioListTile<RegionCode>(
          title: Text(tzText),
          groupValue: model.selectedRegion,
          value: model.selectedRegion,
          onChanged: (value) {
            print('at on chaged');
            model.setRegion(value);
          },
        ),
        // Text(keText),
      ]);
    });

    final _fields = Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[Container(
        width: 100.0,
        child:_drawField),Container (
          width: 100.0,
          child:_regionSwitcher)],
    );

    final _searchButton = Row(
      children: <Widget>[
        Expanded(
          child: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    textColor: Colors.white,
                    color: model.isSearching ? Colors.red : Colors.brown,
                    child: Text(model.isSearching ? cancelText : searchText),
                    onPressed: model.isSearching
                        ? () => _stopSearch(model)
                        : () => _startSearch(model)),
              );
            },
          ),
        ),
      ],
    );

    final _loadingSection = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        print('$tag isSearching is ${model.isSearching}');
        return model.isSearching
            ? LinearProgressIndicator(
                value: model.progressValue,
              )
            : Container();
      },
    );

    final _resultsSection = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
            itemCount: model.drawsSearchResults.length,
            itemBuilder: ((context, index) {
              if (model.drawsSearchResults.length == 0) return Container();
              return ResultItemView(
                result: model.drawsSearchResults[index],
              );
            }));
      },
    );

    final _messageSection = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.searchResultMessage != null
            ? Text(model.searchResultMessage)
            : Container();
      },
    );

    final _slider = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Slider(
          onChanged: (double value) => model.updateLimitValue(value),
          value: model.limitValue,
          min: 10.0,
          max: 1000.0,
          divisions: 99,
        );
      },
    );

    final _limitInfoSection = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Text(
          'Search through ${model.limitValue.round()} pages',
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );

    return Column(
      children: <Widget>[
        _fields,
        _slider,
        _limitInfoSection,
        _searchButton,
        Expanded(child: _resultsSection),
        _messageSection,
        _loadingSection
      ],
    );
  }
}
