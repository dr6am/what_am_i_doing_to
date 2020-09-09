import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_am_i_doing_to/bloc/tasksList.dart';
import 'package:what_am_i_doing_to/models/TaskModel.dart';
import 'package:what_am_i_doing_to/screens/SplashScreen.dart';

import 'package:what_am_i_doing_to/screens/home-screen.dart';
import 'package:what_am_i_doing_to/screens/target-details-screen.dart';

import 'db/db_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.initializeDatabase();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // var themeMode = ValueNotifier(Brightness.light);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      this.brightness = WidgetsBinding.instance.window.platformBrightness;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
    return MultiProvider(
      providers: [
        Provider<TasksBloc>(create: (_) => TasksBloc([])),
      ],
      child: Platform.isIOS
          ? CupertinoApp(
              debugShowCheckedModeBanner: false,
              title: 'What am i doing to',
              theme: brightness == Brightness.light
                  ? CupertinoThemeData(
                      primaryColor: CupertinoColors.darkBackgroundGray,
                      primaryContrastingColor: CupertinoColors.white,
                      scaffoldBackgroundColor:
                          CupertinoColors.extraLightBackgroundGray,
                      textTheme: CupertinoTextThemeData(
                          primaryColor: CupertinoColors.darkBackgroundGray,
                          textStyle: TextStyle(
                              color: CupertinoColors.darkBackgroundGray,
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                    )
                  : CupertinoThemeData(
                      primaryColor: CupertinoColors.extraLightBackgroundGray,
                      primaryContrastingColor: CupertinoColors.black,
                      scaffoldBackgroundColor:
                          CupertinoColors.darkBackgroundGray,
                      textTheme: CupertinoTextThemeData(
                          primaryColor:
                              CupertinoColors.extraLightBackgroundGray,
                          textStyle: TextStyle(
                              color: CupertinoColors.extraLightBackgroundGray,
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                    ),
              routes: {
                SplashScreen.routeName: (context) => SplashScreen(),
                HomeScreen.routeName: (context) => HomeScreen(),
                TargetDetailsScreen.routeName: (context) =>
                    TargetDetailsScreen(),
              },
              initialRoute: HomeScreen.routeName,
            )
          : MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'What am i doing to',
              theme: ThemeData(
                  fontFamily: "SF",
                  accentColor: Colors.grey[800],
                  backgroundColor: CupertinoColors.extraLightBackgroundGray,
                  primaryColorDark: CupertinoColors.darkBackgroundGray,
                  primaryColor: Colors.white,
                  textTheme: TextTheme(
                    headline1: TextStyle(
                      color: Color(0x31313100),
                      fontFamily: "SF-Rounded",
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                    headline4: TextStyle(
                      color: Color(0x31313100),
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  )),
              darkTheme: ThemeData(
                  fontFamily: "SF",
                  accentColor: Colors.grey[200],
                  backgroundColor: CupertinoColors.darkBackgroundGray,
                  primaryColorDark: CupertinoColors.extraLightBackgroundGray,
                  scaffoldBackgroundColor: CupertinoColors.darkBackgroundGray,
                  primaryColor: Colors.black,
                  textTheme: TextTheme(
                    headline1: TextStyle(
                      color: Color(0x00F1F1F1),
                      fontFamily: "SF-Rounded",
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                    headline4: TextStyle(
                      color: Color(0x00F1F1F1),
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  )),
              initialRoute: HomeScreen.routeName,
              routes: {
                SplashScreen.routeName: (context) => SplashScreen(),
                HomeScreen.routeName: (context) => HomeScreen(),
                TargetDetailsScreen.routeName: (context) =>
                    TargetDetailsScreen(),
              },
            ),
    );
  }
}
