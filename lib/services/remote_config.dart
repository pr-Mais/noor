import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:noor/constants/strings.dart';
import 'package:noor/services/prefs.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  Duration minimumFetchInterval = const Duration(hours: 1);
  Duration timeout = const Duration(seconds: 20);

  static RemoteConfigService instance = RemoteConfigService._();

  RemoteConfigService._() {
    SharedPrefsService.putBool('CONFIG_STATE', true);

    _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        minimumFetchInterval: minimumFetchInterval,
        fetchTimeout: timeout,
      ),
    );

    _remoteConfig.setDefaults(<String, dynamic>{
      'noorThker': Strings.noorThekrDefault,
    });
  }

  Future<String> fetchNoorRC() async {
    if (SharedPrefsService.getBool('CONFIG_STATE')) {
      SharedPrefsService.putBool('CONFIG_STATE', false);

      try {
        // Issue open in remote_config plugin: https://github.com/FirebaseExtended/flutterfire/issues/6196
        await Future.delayed(const Duration(seconds: 1));
        await _remoteConfig.fetchAndActivate();
      } catch (e) {
        rethrow;
      }
    }

    return _remoteConfig.getString('noorThker');
  }
}
