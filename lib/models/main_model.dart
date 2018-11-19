import 'package:scoped_model/scoped_model.dart';
import 'package:tatua/models/result.dart';
import 'package:tatua/values/codes.dart';
import 'package:tatua/values/strings.dart';
import 'package:http/http.dart' as http;

const _tag = 'MainModel:';

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
  double _progressValue = 0.0;
  double get progressValue => _progressValue;
  RegionCode _selectedRegion = RegionCode.TZ;
  RegionCode get selectedRegion => _selectedRegion;
  bool _regionValue = false;
  bool get regionValue => _regionValue;

  void setRegion(RegionCode value) {
    print('$_tag the value is: $value');
    _selectedRegion = value;
    notifyListeners();
  }

  updateLimitValue(double newValue) {
    _limitValue = newValue;
    notifyListeners();
  }

  search(String query) {
    _isSearching = true;
    _drawsSearchResults.clear();
    print('$_tag at search\nisSearching is $_isSearching');
    notifyListeners();

    final pageCountLimit = _limitValue.round();

    for (var curPage = 1; curPage <= pageCountLimit; curPage++) {
      print('$_tag at for loop current page is $curPage');
      print('$_tag progress value is $_progressValue');
      if (!_isSearching) {
        print('$_tag is not searching, breaking');
        break;
      } else
        _fetchData(query, curPage);
    }
  }

  cancelSearch() {
    _isSearching = false;
    _searchResultMessage = 'Search has been canceled';
    notifyListeners();
  }

  Map<RegionCode, String> regionMap = {
    RegionCode.TZ: TATU_URL_HEAD,
    RegionCode.KE: TATU_KENYA_URL_HEAD
  };

  _fetchData(String query, int curPage) async {
    print('$_tag at _fetchData');
    final url =
        '${regionMap[_selectedRegion]}$curPage'; //'$TATU_URL_HEAD$curPage';
    print('the selected region is: $_selectedRegion\ncurrent url is: $url');
    final http.Response res =
        await http.get(url, headers: {'User-Agent': 'Mozilla/5.0'});

    if (res.statusCode != 200) {
      _drawsSearchStatus = StatusCode.failed;
      _searchResultMessage = 'Error on fetching data from page $curPage';
      _isSearching = false;
      notifyListeners();
    } else {
      final _body = res.body;
      _checkIfPageContainsQuery(_body, query, curPage);
    }
  }

  _checkIfPageContainsQuery(String body, String query, int curPage) {
    print('$_tag at _checkIfPageContainsQuery');
    final queryPos = body.indexOf('<td>$query</td>');
    if (queryPos != -1) {
      print('$_tag found $query on page $curPage');
      final pageUrl =
          '${regionMap[_selectedRegion]}$curPage'; //'$TATU_URL_HEAD$curPage';
      final randStartPost = 100;
      /*'375</td> <td>Sun 16th Sep 2018 - 6:20:00</td>'.length;*/
      final randomStartPosForDate = queryPos - randStartPost;
      final datePos =
          body.indexOf('<td>', randomStartPosForDate) + '<td>'.length;
      final dateEndPos = body.indexOf('</td>', datePos);
      final date = body.substring(datePos, dateEndPos);
      print('the date is $date');
      final result = Result(pageUrl, curPage, date);
      drawsSearchResults.add(result);
    }

    if (curPage == _limitValue.round()) {
      _isSearching = false;
      _searchResultMessage =
          'Finished searching and found ${_drawsSearchResults.length} results';
      print('$_tag at checking last page,\nisSearching is $_isSearching');
    }
    _progressValue = curPage / _limitValue;
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
