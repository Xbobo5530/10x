import 'package:scoped_model/scoped_model.dart';
import 'package:tatua/models/result.dart';
import 'package:tatua/values/strings.dart';
import 'package:http/http.dart' as http;

const tag = 'MainModel:';

abstract class DrawModel extends Model {
  StatusCode _drawsSearchStatus;
  StatusCode get drawsSearchStatus => _drawsSearchStatus;
  List<Result> _drawsSearchResults = <Result>[];
  List<Result> get drawsSearchResults => _drawsSearchResults;
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  String _searchResultMessage;
  String get searchResultMessage => _searchResultMessage;
  double _limitValue = 10.0;
  double get limitValue => _limitValue;
  int _currentPageNumber = 1;

  updateLimitValue(double newValue) {
    _limitValue = newValue;
    notifyListeners();
  }

  search(String query) {
    print('$tag isSearching is $_isSearching');
    _isSearching = true;
    _drawsSearchResults.clear();
    _currentPageNumber = 1;
    notifyListeners();

    final pageCountLimit = _limitValue.round();

    for (_currentPageNumber = 1;
        _currentPageNumber <= pageCountLimit;
        _currentPageNumber++) {
      print(_currentPageNumber);
      if (!_isSearching)
        break;
      else
        _fetchData(query);
    }
  }

  cancelSearch() {
    _isSearching = false;
    _searchResultMessage = 'Search has been canceled';
    notifyListeners();
  }

  _fetchData(String query) async {
    final url = '$TATU_URL_HEAD$_currentPageNumber';
    final http.Response res =
        await http.get(url, headers: {'User-Agent': 'Mozilla/5.0'});
    if (res.statusCode != 200) {
      _drawsSearchStatus = StatusCode.failed;
      _searchResultMessage = 'Error on fetching data}';
      notifyListeners();
    } else {
      final _body = res.body;
      _checkIfPageContainsQuery(_body, query);
    }
  }

  _checkIfPageContainsQuery(String body, String query) {
    final queryPos = body.indexOf('<td>$query</td>');
    if (queryPos == -1)
      _currentPageNumber++;
    else {
      print('found $query on page $_currentPageNumber');
      final pageUrl = '$TATU_URL_HEAD$_currentPageNumber';
      final randStartPost = 100;
      /*'375</td> <td>Sun 16th Sep 2018 - 6:20:00</td>'.length;*/
      final randomStartPosForDate = queryPos - randStartPost;
      final datePos =
          body.indexOf('<td>', randomStartPosForDate) + '<td>'.length;
      final dateEndPos = body.indexOf('</td>', datePos);
      final date = body.substring(datePos, dateEndPos);
      print('the date is $date');
      final result = Result(pageUrl, _currentPageNumber, date);
      drawsSearchResults.add(result);
      _currentPageNumber++;
    }

    if (_currentPageNumber == _limitValue.round()) {
      _isSearching = false;
      _searchResultMessage =
          'Finished searching and found ${_drawsSearchResults.length} results';
    }
    notifyListeners();
  }
}

abstract class RundownModel extends Model {
  List<int> _rundownSingleList = <int>[];
  List<int> get rundownSingleList => _rundownSingleList;

  computeRunDown(String runDown, String draw) {
    final runDownFirstPos = int.parse(runDown[0]);
    final runDownSecondPos = int.parse(runDown[1]);
    final runDownThirdPos = int.parse(runDown[2]);

    final drawFirstPos = int.parse(draw[0]);
    final drawSecondPos = int.parse(draw[1]);
    final drawThirdPos = int.parse(draw[2]);
    print(
        'rFirst: $runDownFirstPos, rSecond: $runDownSecondPos, rThird: $runDownThirdPos\n'
        'dFirst $drawFirstPos, dSecond: $drawSecondPos, dThird: $drawThirdPos');

    final runDownMatrix = List(12);
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

    var singleList = <int>[];
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

    print(runDownMatrix);
    _rundownSingleList = singleList;
    notifyListeners();
  }
}

class MainModel extends Model with DrawModel, RundownModel {}

enum StatusCode { success, waiting, failed }
