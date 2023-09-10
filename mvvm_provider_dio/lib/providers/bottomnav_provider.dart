import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {

  // current index
  int _currentIndex = 0;
  
  // getter current index
  int get currentIndex => _currentIndex;

  // title
  String _title = 'MVVM Provider Dio';
  
  // getter title
  String get title => _title;

  // method update index
  void updateIndex(int index) {
    _currentIndex = index;
    switch (index) {
      case 0:
        _title = 'Users';
        break;
      case 1:
        _title = 'Products';
        break;
      case 2:
        _title = 'Maps';
        break;
    }
    notifyListeners();
  }

}