import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int _uid = 0;

  int get uid => _uid;

  void setUid(int newUid) {
    _uid = newUid;
    notifyListeners(); // Notifies widgets listening to rebuild
  }
}
