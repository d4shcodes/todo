import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  late final StreamSubscription _subscription;

  ConnectivityProvider() {
    checkInitialStatus();

    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        _isConnected = true;
        notifyListeners(); // Notify that connection is restored
      } else {
        _isConnected = false;
        notifyListeners(); // Notify that connection is lost
      }
    });
  }

  Future checkInitialStatus() async {
    notifyListeners();

    final result = await InternetConnection().hasInternetAccess;
    _isConnected = result;

    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
