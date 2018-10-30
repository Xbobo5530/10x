import 'package:scoped_model/scoped_model.dart';
import 'package:tatua/models/result.dart';
import 'package:tatua/values/strings.dart';
import 'package:http/http.dart' as http;

abstract class DrawModel extends Model {
  StatusCode _drawsSearchStatus;
  StatusCode get drawsSearchStatus => _drawsSearchStatus;
  List<Result> _drawsSearchResults = <Result>[];
  List<Result> get drawsSearchResults => _drawsSearchResults;
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  String _searchResultMessage;
  String get searchResultMessage => _searchResultMessage;
  int _currentPageNumber = 1;

  search(String query, String pageCountLimitString) {
    _isSearching = true;
    notifyListeners();

    final pageCountLimit = int.parse(pageCountLimitString);
    _drawsSearchResults.clear();
    for (_currentPageNumber = 1;
        _currentPageNumber <= pageCountLimit;
        _currentPageNumber++) {
      print(_currentPageNumber);
      if (!_isSearching) break;
      _fetchData(query, pageCountLimit);
    }
  }

  cancelSearch() {
    _isSearching = false;
    _searchResultMessage = 'Search has been canceled';
    notifyListeners();
  }

  _fetchData(String query, int limit) async {
    if (_currentPageNumber == limit) _isSearching = false;

    var url = '$TATU_URL_HEAD$_currentPageNumber';

    final http.Response res =
        await http.get(url, headers: {'User-Agent': 'Mozilla/5.0'});
    if (res.statusCode != 200)
      _drawsSearchStatus = StatusCode.failed;
    else {
      final _body = res.body;
      _checkIfPageContainsQuery(_body, query, limit);
    }
  }

  void _checkIfPageContainsQuery(String body, String query, int limit) {
    var queryPos = body.indexOf('<td>$query</td>');
    if (queryPos == -1)
      _currentPageNumber++;
    else {
      print('found $query on current page');
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
      notifyListeners();
    }

    if (_currentPageNumber == limit) {
      _isSearching = false;
      _searchResultMessage =
          'Finished searching and found ${_drawsSearchResults.length} results';
      notifyListeners();
    }
    notifyListeners();
  }
}

abstract class RundownModel extends Model {
  List<int> _rundownSingleList = <int>[];
  List<int> get rundownSingleList => _rundownSingleList;

  computeRunDown(String runDown, String draw) {
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
