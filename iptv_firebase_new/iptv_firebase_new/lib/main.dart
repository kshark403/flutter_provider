import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tv/app.dart';
import 'package:tv/manger/themes.dart';
import 'package:tv/page/User.dart';
import 'package:tv/page/add-channel.dart';
import 'package:tv/page/add-section.dart';
import 'package:tv/page/edit-password.dart';
import 'package:tv/page/edit-profile.dart';
import 'package:tv/page/forgot_password.dart';
import 'package:tv/page/notifications.dart';
import 'package:tv/page/signin.dart';
import 'package:tv/page/signup.dart';
import 'package:tv/page/splash.dart';
import 'package:tv/page/tabbar.dart';
import 'package:tv/page/import-m3u.dart';

import 'manger/init.dart'
    if (dart.library.html) 'manger/web_init.dart'
    if (dart.library.io) 'manger/io_init.dart';
import 'models/lang.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: _locale,
          supportedLocales: const [
            Locale("ar"),
            Locale("en", "US"),
          ],
          localizationsDelegates: [
            AppLocalization.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeListResolutionCallback: (deviceLocale, supportedLocales) {
            for (var local in supportedLocales) {
              if (local.languageCode == deviceLocale![0].languageCode) {
                return local;
              }
            }
            return supportedLocales.first;
          },
          title: 'Flutter',
          theme: CustomTheme.lightTheme,
          darkTheme: CustomTheme.darkTheme,
          initialRoute: "/Splash",
          themeMode: Provider.of<CustomTheme>(context).isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          onGenerateRoute: (settings) {
            final arguments = settings.arguments;
            // settings.name = "/TabBarPage";
            switch (settings.name) {
              // switch ("/TabBarPage") {
              case '/Splash':
                return MaterialPageRoute(builder: (_) => Splash());
              case '/SignIn':
                return MaterialPageRoute(
                    builder: (_) => SignIn(
                          message: arguments,
                        ));
              case '/SignUp':
                return MaterialPageRoute(builder: (_) => const Signup());
              case '/ForgotPassword':
                return MaterialPageRoute(builder: (_) => ForgotPassword());
              case '/TabBarPage':
                return MaterialPageRoute(
                    builder: (_) => TabBarPage(
                          userType: arguments,
                        ));
              case '/addsection':
                return MaterialPageRoute(builder: (_) => addsection());
              case '/addchannel':
                return MaterialPageRoute(builder: (_) => addchannel());
              case '/laddchannel':
                return MaterialPageRoute(builder: (_) => laddchannel());
              case '/Notification':
                return MaterialPageRoute(builder: (_) => const Notifications());
              case '/Users':
                return MaterialPageRoute(builder: (_) => const Users());
              case '/EditPassword':
                return MaterialPageRoute(builder: (_) => EditPassword());
              case '/ImportM3U':
                return MaterialPageRoute(builder: (_) => import_m3u());
              // return MaterialPageRoute(builder: (_) => MyHomePage());
              case '/EditProfile':
                return MaterialPageRoute(builder: (_) => EditProfile());
              default:
                return MaterialPageRoute(
                    builder: (_) => Scaffold(
                          body: Center(
                            child:
                                Text('No route defined for ${settings.name}'),
                          ),
                        ));
            }
          },
        ));
  }
}
