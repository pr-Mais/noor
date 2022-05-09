import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:noor/models/settings.dart';
import 'package:noor/services/prefs.dart';

class FCMService {
  FCMService._();

  static final FCMService instance = FCMService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // For iOS
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _firebaseMessaging.subscribeToTopic('PUSH_RC');
  }

  Future<void> unsubscribe() async {
    SharedPrefsService.putBool('generalNotifications', false);
    GetIt.I<AppSettings>().generalNotification = false;

    await _firebaseMessaging.unsubscribeFromTopic('general_notifications');
  }

  Future<void> subscribe() async {
    SharedPrefsService.putBool('generalNotifications', true);
    GetIt.I<AppSettings>().generalNotification = true;

    await _firebaseMessaging.subscribeToTopic('general_notifications');
  }
}
