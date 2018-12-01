import 'package:scoped_model/scoped_model.dart';

abstract class BreakdownModel extends Model {
  String _breakDownResult;
  String get breakDownResult => _breakDownResult;

  Map<String, dynamic> codeMap = {
    '0': '709',
    '1': '810',
    '2': '921',
    '3': '032',
    '4': '143',
    '5': '254',
    '6': '365',
    '7': '476',
    '8': '587',
    '9': '698'
  };

  computeBreakdown(String code, String draw) {
    print('code: $code draw: $draw');
    final codeDraw = codeMap[int.parse(code)].toString();

    /// formula: [codeDraw] - [draw]
    final firstCodeDrawDigit = int.parse(codeDraw[0]);
    final secondCodeDrawDigit = int.parse(codeDraw[1]);
    final thirdCodeDrawDigit = int.parse(codeDraw[2]);

    final firstDrawDigit = int.parse(draw[0]);
    final secondDrawDigit = int.parse(draw[1]);
    final thirdDrawDigit = int.parse(draw[2]);

    print('$firstCodeDrawDigit - $secondCodeDrawDigit - $thirdCodeDrawDigit');
    print('$firstDrawDigit - $secondDrawDigit - $thirdDrawDigit');

    /// first draw digit
    final firstDigitForFirstResult = firstCodeDrawDigit < firstDrawDigit
        ? (firstCodeDrawDigit + 10) - firstDrawDigit
        : firstCodeDrawDigit - firstDrawDigit;
    final secondDigitForFirstResult = secondCodeDrawDigit < firstDrawDigit
        ? (secondCodeDrawDigit + 10) - firstDrawDigit
        : secondCodeDrawDigit - firstDrawDigit;
    final thirdDigitForFirstResult = thirdCodeDrawDigit < firstDrawDigit
        ? (thirdCodeDrawDigit + 10) - firstDrawDigit
        : thirdCodeDrawDigit - firstDrawDigit;

    /// second draw digit
    final secondDigitForSecondResult =
        secondDigitForFirstResult < secondDrawDigit
            ? (secondDigitForFirstResult + 10) - secondDrawDigit
            : secondDigitForFirstResult - secondDrawDigit;
    final thirdDigitForSecondResult = thirdDigitForFirstResult < secondDrawDigit
        ? (thirdDigitForFirstResult + 10) - secondDrawDigit
        : thirdDigitForFirstResult - secondDrawDigit;

    /// third draw digit
    final thirdDigitForThirdResult = thirdDigitForSecondResult < thirdDrawDigit
        ? (thirdDigitForSecondResult + 10) - thirdDrawDigit
        : thirdDigitForSecondResult - thirdDrawDigit;

    print(
        '$firstDigitForFirstResult - $secondDigitForSecondResult - $thirdDigitForThirdResult');
    _breakDownResult =
        '$firstDigitForFirstResult$secondDigitForSecondResult$thirdDigitForThirdResult';
    notifyListeners();
  }
}
