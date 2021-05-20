import 'package:flutter/foundation.dart';
import 'package:noor/exports/services.dart' show SharedPrefsService;
import 'package:noor/exports/constants.dart' show DefaultSettings;

class SettingsModel with ChangeNotifier {
  /// Font Size, the scale factor by which the font size is multiplied
  /// prefs key `fontSize`
  double _fontSize = SharedPrefsService.getDouble(
    'fontSize',
    defValue: DefaultSettings.fontSize,
  );
  double get fontSize => _fontSize;
  set fontSize(double value) {
    _fontSize = value;
    SharedPrefsService.putDouble('fontSize', value);
    notifyListeners();
  }

  /// Font Type
  /// prefs key `fontType`
  String _fontType = SharedPrefsService.getString('fontType',
      defValue: DefaultSettings.fontType);
  String get fontType => _fontType;
  set fontType(String value) {
    _fontType = value;
    SharedPrefsService.putString('fontType', value);
    notifyListeners();
  }

  /// Show or hide Tashkeel (the tones above letters in Arabic)
  /// prefs key `tashkeel`
  bool _tashkeel = SharedPrefsService.getBool('tashkeel',
      defValue: DefaultSettings.tashkeel);
  bool get tashkeel => _tashkeel;
  set tashkeel(bool value) {
    _tashkeel = value;
    SharedPrefsService.putBool('tashkeel', value);
    notifyListeners();
  }

  /// Enable auto jumping to the next card
  /// prefs key `autoJump`
  bool _autoJump = SharedPrefsService.getBool('autoJump',
      defValue: DefaultSettings.autoJump);
  bool get autoJump => _autoJump;
  set autoJump(bool value) {
    _autoJump = value;
    SharedPrefsService.putBool('autoJump', value);
    notifyListeners();
  }

  /// Show Counter for Athkar with a count > 1
  /// prefs key `showCounter`
  bool _showCounter = SharedPrefsService.getBool('showCounter',
      defValue: DefaultSettings.showCounter);
  bool get showCounter => _showCounter;
  set showCounter(bool value) {
    _showCounter = value;
    SharedPrefsService.putBool('showCounter', value);
    notifyListeners();
  }

  /// Vibration on click in Athkar section
  /// prefs key `vibrate`
  bool _vibrate =
      SharedPrefsService.getBool('vibrate', defValue: DefaultSettings.vibrate);
  bool get vibrate => _vibrate;
  set vibrate(bool value) {
    _vibrate = value;
    SharedPrefsService.putBool('vibrate', value);
    notifyListeners();
  }

  /// Vibration strength for every click on a card in Athkar section
  /// prefs key `vibrationClick`
  String _vibrationClick = SharedPrefsService.getString('vibrationClick',
      defValue: DefaultSettings.vibrationClick);
  String get vibrationClick => _vibrationClick;
  set vibrationClick(String value) {
    _vibrationClick = value;
    SharedPrefsService.putString('vibrationClick', value);
    notifyListeners();
  }

  /// Vibration strength when count is done for a card in Athkar section
  /// prefs key `vibrationDone`
  String _vibrationDone = SharedPrefsService.getString('vibrationDone',
      defValue: DefaultSettings.vibrationClick);
  String get vibrationDone => _vibrationDone;
  set vibrationDone(String value) {
    _vibrationDone = value;
    SharedPrefsService.putString('vibrationDone', value);
    notifyListeners();
  }

  /// Vibration on click in Counter page
  /// prefs key `vibrateCounter`
  bool _vibrateCounter = SharedPrefsService.getBool('vibrateCounter',
      defValue: DefaultSettings.vibrateCounter);
  bool get vibrateCounter => _vibrateCounter;
  set vibrateCounter(bool value) {
    _vibrateCounter = value;
    SharedPrefsService.putBool('vibrateCounter', value);
    notifyListeners();
  }

  /// Vibration strength for every click in the Counter page
  /// prefs key `vibrationClickCounter`
  String _vibrationClickCounter = SharedPrefsService.getString(
      'vibrationClickCounter',
      defValue: DefaultSettings.vibrationClick);
  String get vibrationClickCounter => _vibrationClickCounter;
  set vibrationClickCounter(String value) {
    _vibrationClickCounter = value;
    SharedPrefsService.putString('vibrationClickCounter', value);
    notifyListeners();
  }

  /// Vibration strength when the counter is a multiply of a percent
  /// prefs key `vibrationHunderds`
  String _vibrationHunderds = SharedPrefsService.getString('vibrationHunderds',
      defValue: DefaultSettings.vibrationHunderds);
  String get vibrationHunderds => _vibrationHunderds;
  set vibrationHunderds(String value) {
    _vibrationHunderds = value;
    SharedPrefsService.putString('vibrationHunderds', value);
    notifyListeners();
  }

  /// Theme => `light_theme`, `dark_theme`, `system_theme`
  /// prefs key `theme`
  String _theme =
      SharedPrefsService.getString('theme', defValue: DefaultSettings.theme);
  String get theme => _theme;
  set theme(String value) {
    _theme = value;
    SharedPrefsService.putString('theme', value);
    notifyListeners();
  }

  /// General FCM notifications
  /// prefs key `generalNotifications`
  bool _generalNotification = SharedPrefsService.getBool(
    'generalNotifications',
    defValue: DefaultSettings.generalNotifications,
  );
  bool get generalNotification => _generalNotification;
  set generalNotification(bool value) {
    _generalNotification = value;
    SharedPrefsService.putBool('generalNotifications', value);
    notifyListeners();
  }
}
