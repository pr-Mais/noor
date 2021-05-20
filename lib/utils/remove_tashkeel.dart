class Tashkeel {
  static remove(String string) {
    String tmp = string.replaceAll(
        RegExp(
          r'[\u{0618}\u{0619}\u{061A}\u{064B}\u{064C}\u{064D}\u{064E}\u{064F}\u{0650}\u{0651}\u{0652}\u{0653}\u{0651}]',
          unicode: true,
        ),
        '');

    return tmp;
  }
}
