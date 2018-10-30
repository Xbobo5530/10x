import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tatua/models/main_model.dart';
import 'package:tatua/values/strings.dart';
import 'package:tatua/views/results_item_view.dart';

class DrawsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _drawController = TextEditingController();
    final _limitController = TextEditingController();

    _startSearch(MainModel model) {
      print('start search is called');

      final draw = _drawController.text.trim();
      final limit = _limitController.text.trim();

      if (draw.isNotEmpty && limit.isNotEmpty) {
        model.search(draw, limit);
        _drawController.clear();
        _limitController.clear();
        FocusScope.of(context).requestFocus(FocusNode());
      }
    }

    _stopSearch(MainModel model) {
      print('stop search is called');
      model.cancelSearch();
      final snackBar = SnackBar(content: Text(model.searchResultMessage));
      Scaffold.of(context).showSnackBar(snackBar);
    }

    final _drawField = Container(
      width: 150.0,
      child: TextField(
        maxLength: 3,
        controller: _drawController,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          labelText: enterDrawHint,
        ),
      ),
    );

    final _limitField = Container(
      width: 150.0,
      child: TextField(
        controller: _limitController,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          labelText: enterLimitHint,
        ),
      ),
    );

    final _fields = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _drawField,
        _limitField,
      ],
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
        return model.isSearching ? LinearProgressIndicator() : Container();
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

    return Column(
      children: <Widget>[
        _fields,
        _searchButton,
        Expanded(child: _resultsSection),
        _messageSection,
        _loadingSection
      ],
    );
  }
}
