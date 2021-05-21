import 'package:flutter/foundation.dart';

class AthkarCounter with ChangeNotifier {
  AthkarCounter(this._position);

  int _position;

  int get position => _position;

  void decrement() {
    _position--;

    notifyListeners();
  }
}
