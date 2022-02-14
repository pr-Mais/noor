class NoorColors {
  static LightModeColors get light => LightModeColors();
  static DarkModeColors get dark => DarkModeColors();

  final int primary = 0xff6db7e5;
  final int subhaListItemBg = 0;
  final int subhaLockBg = 0;
}

class DarkModeColors extends NoorColors {
  @override
  int get subhaListItemBg => 0xff1D274C;
  @override
  int get subhaLockBg => 0xff375089;
}

class LightModeColors extends NoorColors {
  @override
  int get subhaListItemBg => 0xffffffff;
  @override
  int get subhaLockBg => 0xffb3b3b3;
}
