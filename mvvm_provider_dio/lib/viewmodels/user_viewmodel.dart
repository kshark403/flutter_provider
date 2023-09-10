import 'package:flutter/foundation.dart';
import 'package:mvvm_provider_dio/app.dart';
import 'package:mvvm_provider_dio/models/user_model.dart';
import 'package:mvvm_provider_dio/services/user_api_service.dart';

class UserViewModel extends ChangeNotifier {
  
  // Create UserApiService instance
  final UserApiService _userApiService = UserApiService();

  // Create List of User
  List<UserModel> _users = [];

  // Getter
  List<UserModel> get users => _users;

  // Fetch User
  Future<void> fetchUser() async {
    try {
    _users = await _userApiService.getUser();
    notifyListeners();
    } catch (e) {
      logger.e('Error fetching users: $e');
    }
  }
  
}