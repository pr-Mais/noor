extension ToArabicNumbers on String {
  String arabicDigit() {
    const int latinArabicUtfDistance = 1584;

    final List<int> arabicCodeUnits =
        codeUnits.map((int unit) => unit + latinArabicUtfDistance).toList();
    //final sign = i.isNegative ? '−' : '';
    return String.fromCharCodes(arabicCodeUnits);
  }
}
