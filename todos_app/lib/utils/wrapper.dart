import 'package:todos_app/provider/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomWrapper extends StatefulWidget {
  final Widget child;

  const CustomWrapper({super.key, required this.child});

  @override
  State<CustomWrapper> createState() => _CustomWrapperState();
}

class _CustomWrapperState extends State<CustomWrapper> with WidgetsBindingObserver {
  late SharedPreferences preferences;

  // catch when the app comes back to the foreground,
  // then force both your connectivity and session providers to re-check immediately
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<ConnectivityProvider>().checkInitialStatus();
    }

    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<ConnectivityProvider>().isConnected;

    if (!isConnected) {
      return Scaffold(
        body: Center(
          child: Transform.scale(scale: MediaQuery.of(context).size.width * 0.0018, child: CircularProgressIndicator()),
        ),
      );
    }

    return widget.child;
  }
}
