import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tatua/models/result.dart';
import 'package:tatua/pages/run_down.dart';
import 'package:tatua/values/strings.dart';
import 'package:tatua/views/results_item_view.dart';

class DrawsPage extends StatefulWidget {
  @override
  _DrawsPageState createState() => _DrawsPageState();
}

class _DrawsPageState extends State<DrawsPage> {
  var _searchFieldController = new TextEditingController();
  var _pageCountLimit = 10.0;
  List<Result> results = new List();
  var _messageSection = new Container();
  var _resultsSection = new Container();
  var _isSearching = false;
  var _searchButton;
  var _loadingSection = Container();
  var _body;

  @override
  Widget build(BuildContext context) {
    _fetchData(int _pageNumber, String query, int limit) async {
      var url = '$TATU_URL_HEAD$_pageNumber';
      await http
          .get(url, headers: {'User-Agent': 'Mozilla/5.0'}).then((response) {
        if (response.statusCode == 200) {
          _body = response.body;
          var queryPos = _body.indexOf('<td>$query</td>');
          if (queryPos != -1) {
            // query exists on current page
            print('found $query on current page');
            //get the page url
            var pageUrl = '$TATU_URL_HEAD$_pageNumber';
            var randStartPost = 100;
            /*'375</td> <td>Sun 16th Sep 2018 - 6:20:00</td>'.length;*/
            var randomStartPosForDate = queryPos - randStartPost;
            var datePos =
                _body.indexOf('<td>', randomStartPosForDate) + '<td>'.length;
            var dateEndPos = _body.indexOf('</td>', datePos);
            var date = _body.substring(datePos, dateEndPos);
            print('the date is $date');
            var result = Result(pageUrl, _pageNumber, date);
            setState(() {
              results.add(result);
              _resultsSection = Container(
                height: 40.0,
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (results.isNotEmpty) {
                      var result = results[index];
                      return ResultItemView(result);
                    }
                  },
                ),
              );
            });
            _pageNumber++;
          } else {
            //query not found on current page
            _pageNumber++;
            print('query not found');
          }
          if (_pageNumber == limit) {
            setState(() {
              _messageSection = Container(
                child: Center(
                  child: Text(
                    'Finished searching\nFound ${results.length} results',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
              _isSearching = false;
            });
          }
        } else {
          _messageSection = Container(
            child: Center(
              child: Text(
                'Please check your network\n'
                    'The status code is: ${response.statusCode}\n'
                    'The message is: ${response.reasonPhrase}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      });
    }

    _search(String query, int pageCountLimit) async {
      results.clear();
      _resultsSection = Container();
      for (var _pageNumber = 1; _pageNumber <= pageCountLimit; _pageNumber++) {
        print(_pageNumber);
        if (_isSearching) {
          Container(
            child: LinearProgressIndicator(),
          );
          await _fetchData(_pageNumber, query, pageCountLimit);
        } else {
          _loadingSection = Container();
          break;
        }
      }
    }

    _startSearch() {
      print('start search is called');
      var query = _searchFieldController.text;
      if (query.isNotEmpty) {
        setState(() {
          _isSearching = true;
          FocusScope.of(context).requestFocus(FocusNode());
          _searchFieldController.clear();
          _search(query, _pageCountLimit.round());
        });
      } else {
        _messageSection = Container(
          child: Text(
            enterDrawText,
            textAlign: TextAlign.center,
          ),
        );
      }
    }

    _stopSearch() {
      print('stop search is called');
      setState(() {
        _isSearching = false;
      });
    }

    _searchButton = RaisedButton(
        color: _isSearching ? Colors.red : Colors.brown,
        textColor: Colors.white,
        child: _isSearching ? Text(stopText) : Text(searchText),
        onPressed: _isSearching ? () => _stopSearch() : () => _startSearch());

    return Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
        ),
        body: PageView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        textAlign: TextAlign.center,
                        maxLength: 3,
                        decoration: InputDecoration(
                            labelText: textFieldLabelText,
                            labelStyle: TextStyle(
                              fontSize: 30.0,
                            )),
                        autofocus: false,
                        controller: _searchFieldController,
                        keyboardType: TextInputType.numberWithOptions(),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slider(
                      min: 10.0,
                      max: 1000.0,
                      divisions: 99,
                      value: _pageCountLimit,
                      onChanged: (value) {
                        setState(() {
                          _pageCountLimit = value;
                        });
                      }),
                ),
                Text(
                    'Search ${_searchFieldController.text} through ${_pageCountLimit.round()} page(s)'),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _searchButton,
                      ),
                    ),
                  ],
                ),
                Expanded(child: _resultsSection),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: _messageSection),
                  ],
                ),
                _loadingSection = _isSearching
                    ? Container(child: LinearProgressIndicator())
                    : Container(),
              ],
            ),
            RundownPage(),
          ],
        ));
  }
}
