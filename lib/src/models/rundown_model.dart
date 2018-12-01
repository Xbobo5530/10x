import 'package:scoped_model/scoped_model.dart';

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
