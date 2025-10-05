import 'package:todos_app/constant/taxonomy.dart';
import 'package:todos_app/provider/user_provider.dart';
import 'package:todos_app/provider/connectivity_provider.dart';
import 'package:todos_app/screen/screen_home.dart';
import 'package:todos_app/screen/screen_login.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/size_config.dart';
import 'package:flutter/material.dart';
import 'constant/colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<SharedPreferences> preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    preferences = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig.init(context); // initialize once here
        return MaterialApp(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            );
          },

          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.white,
            fontFamily: 'Poppins',
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            appBarTheme: AppBarTheme(color: AppColors.primary),
          ),
          home: FutureBuilder(
            future: preferences,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Transform.scale(scale: MediaQuery.of(context).size.width * 0.0018, child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Text('Error has occured', style: AppTypography.labelSmall.copyWith(color: AppColors.gray));
              } else if (snapshot.hasData) {
                final staffID = snapshot.data!.getInt('id');
                return staffID != null ? Home() : Login();
              } else {
                return Login();
              }
            },
          ),
        );
      },
    );
  }
}
