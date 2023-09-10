import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

class CustomTheme with ChangeNotifier {
  // bool isDarkMode = Hive.box('storage').get('isDarkMode') ?? false;
  bool isDarkMode = true;
  // bool isDarkMode = false;

  ThemeMode get currentTheme => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
    // Hive.box('storage').put('isDarkMode', isDarkMode);
  }

  static ThemeData get lightTheme {
    // return ThemeData(
    //   primaryColor: Colors.blueGrey,
    //   textTheme: const TextTheme(
    //     headline1: TextStyle(color: Colors.black),
    //     headline2: TextStyle(color: Colors.black),
    //     button: TextStyle(color: Colors.black),
    //     bodyText1: TextStyle(color: Colors.black),
    //     bodyText2: TextStyle(color: Colors.black),
    //   ),
    //   colorScheme:
    //       ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
    // );

    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      canvasColor: const Color(0xFFF0F4F8),
      primaryColor: Colors.blue,
      backgroundColor: Colors.white,
      platform: TargetPlatform.android,
      fontFamily: 'NeoSansArabic',
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.black,
      ),
    );
  }

  static ThemeData get darkTheme {
    // return ThemeData(
    //   textTheme: const TextTheme(
    //     headline1: TextStyle(color: Colors.white),
    //     headline2: TextStyle(color: Colors.white),
    //     button: TextStyle(color: Colors.white70),
    //     bodyText1: TextStyle(color: Colors.white),
    //     bodyText2: TextStyle(color: Colors.white),
    //   ),
    //   colorScheme:
    //       ColorScheme.fromSwatch().copyWith(secondary: Colors.redAccent),
    // );

    return ThemeData(
      scaffoldBackgroundColor: const Color.fromARGB(255, 88, 63, 53),
      canvasColor: Colors.brown,
      primaryColor: Colors.white,
      backgroundColor: Colors.black,
      platform: TargetPlatform.android,
      fontFamily: 'NeoSansArabic',
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.yellow),
    );
  }
}
