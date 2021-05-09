import 'package:flutter/foundation.dart';
import 'package:noor/constants/default_settings.dart';
import 'package:noor/services/prefs.dart';

class SettingsProvider with ChangeNotifier {
  /// Font Size, the scale factor by which the font size is multiplied
  /// prefs key `fontSize`
  double _fontSize = SharedPrefsUtil.getDouble('fontSize', defValue: DefaultSettings.fontSize);
  get fontSize => _fontSize;
  set fontSize(value) {
    _fontSize = value;
    SharedPrefsUtil.putDouble('fontSize', value);
    notifyListeners();
  }

  /// Font Type
  /// prefs key `fontType`
  String _fontType = SharedPrefsUtil.getString('fontType', defValue: DefaultSettings.fontType);
  get fontType => _fontType;
  set fontType(value) {
    _fontType = value;
    SharedPrefsUtil.putString('fontType', value);
    notifyListeners();
  }

  /// Show or hide Tashkeel (the tones above letters in Arabic)
  /// prefs key `tashkeel`
  bool _tashkeel = SharedPrefsUtil.getBool('tashkeel', defValue: DefaultSettings.tashkeel);
  get tashkeel => _tashkeel;
  set tashkeel(value) {
    _tashkeel = value;
    SharedPrefsUtil.putBool('tashkeel', value);
    notifyListeners();
  }

  /// Enable auto jumping to the next card
  /// prefs key `autoJump`
  bool _autoJump = SharedPrefsUtil.getBool('autoJump', defValue: DefaultSettings.autoJump);
  get autoJump => _autoJump;
  set autoJump(value) {
    _autoJump = value;
    SharedPrefsUtil.putBool('autoJump', value);
    notifyListeners();
  }

  /// Show Counter for Athkar with a count > 1
  /// prefs key `showCounter`
  bool _showCounter = SharedPrefsUtil.getBool('showCounter', defValue: DefaultSettings.showCounter);
  get showCounter => _showCounter;
  set showCounter(value) {
    _showCounter = value;
    SharedPrefsUtil.putBool('showCounter', value);
    notifyListeners();
  }

  /// Vibration on click in Athkar section
  /// prefs key `vibrate`
  bool _vibrate = SharedPrefsUtil.getBool('vibrate', defValue: DefaultSettings.vibrate);
  get vibrate => _vibrate;
  set vibrate(value) {
    _vibrate = value;
    SharedPrefsUtil.putBool('vibrate', value);
    notifyListeners();
  }

  /// Vibration strength for every click on a card in Athkar section
  /// prefs key `vibrationClick`
  String _vibrationClick = SharedPrefsUtil.getString('vibrationClick', defValue: DefaultSettings.vibrationClick);
  String get vibrationClick => _vibrationClick;
  set vibrationClick(value) {
    _vibrationClick = value;
    SharedPrefsUtil.putString('vibrationClick', value);
    notifyListeners();
  }

  /// Vibration strength when count is done for a card in Athkar section
  /// prefs key `vibrationDone`
  String _vibrationDone = SharedPrefsUtil.getString('vibrationDone', defValue: DefaultSettings.vibrationClick);
  get vibrationDone => _vibrationDone;
  set vibrationDone(value) {
    _vibrationDone = value;
    SharedPrefsUtil.putString('vibrationDone', value);
    notifyListeners();
  }

  /// Vibration on click in Counter page
  /// prefs key `vibrateCounter`
  bool _vibrateCounter = SharedPrefsUtil.getBool('vibrateCounter', defValue: DefaultSettings.vibrateCounter);
  get vibrateCounter => _vibrateCounter;
  set vibrateCounter(value) {
    _vibrateCounter = value;
    SharedPrefsUtil.putBool('vibrateCounter', value);
    notifyListeners();
  }

  /// Vibration strength for every click in the Counter page
  /// prefs key `vibrationClickCounter`
  String _vibrationClickCounter = SharedPrefsUtil.getString('vibrationClickCounter', defValue: DefaultSettings.vibrationClick);
  get vibrationClickCounter => _vibrationClickCounter;
  set vibrationClickCounter(value) {
    _vibrationClickCounter = value;
    SharedPrefsUtil.putString('vibrationClickCounter', value);
    notifyListeners();
  }

  /// Vibration strength when the counter is a multiply of a percent
  /// prefs key `vibrationHunderds`
  String _vibrationHunderds = SharedPrefsUtil.getString('vibrationHunderds', defValue: DefaultSettings.vibrationHunderds);
  get vibrationHunderds => _vibrationHunderds;
  set vibrationHunderds(value) {
    _vibrationHunderds = value;
    SharedPrefsUtil.putString('vibrationHunderds', value);
    notifyListeners();
  }

  /// Theme => `light_theme`, `dark_theme`, `system_theme`
  /// prefs key `theme`
  String _theme = SharedPrefsUtil.getString('theme', defValue: DefaultSettings.theme);
  String get  theme => _theme;
  set theme(value) {
    _theme = value;
    SharedPrefsUtil.putString('theme', value);
    notifyListeners();
  }


}
