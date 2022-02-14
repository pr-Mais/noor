class NoorColors {
  static LightModeColors get light => LightModeColors();
  static DarkModeColors get dark => DarkModeColors();

  final int primary = 0xff6db7e5;
  final int subhaListItemBg = 0;
}

class DarkModeColors extends NoorColors {
  @override
  int get subhaListItemBg => 0xff1D274C;
}

class LightModeColors extends NoorColors {
  @override
  int get subhaListItemBg => 0xffffffff;
}
