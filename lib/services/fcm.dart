import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  FCMService._();

  static final FCMService instance = FCMService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _initialized = true;
    }
    _firebaseMessaging.subscribeToTopic('PUSH_RC');
  }
}
