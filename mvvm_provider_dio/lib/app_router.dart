// ignore_for_file: prefer_const_constructors

import 'package:mvvm_provider_dio/views/home/home_screen.dart';
import 'package:mvvm_provider_dio/views/userdetail/userdetail_screen.dart';

class AppRouter {

  // Router Map Key
  static const String home = 'home';
  static const String user = 'user';
  static const String userdetail = 'userdetail';

  // Router Map
  static get routes => {
    home: (context) => HomeScreen(),
    userdetail: (context) => UserDetailScreen(),
  };
}