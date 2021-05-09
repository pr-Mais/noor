class ToArabic {
  static String integer(int value) {
    const latinArabicUtfDistance = 1584;

    final arabicCodeUnits =
        '$value'.codeUnits.map((unit) => unit + latinArabicUtfDistance);
    //final sign = i.isNegative ? '−' : '';
    return String.fromCharCodes(arabicCodeUnits);
  }
}
