import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mvvm_provider_dio/app.dart';
import 'package:mvvm_provider_dio/constants/network_api.dart';
import 'package:mvvm_provider_dio/models/user_model.dart';
import 'package:mvvm_provider_dio/services/dio_config.dart';

class UserApiService {
  // Create Dio instance
  final Dio _dio = DioConfig.dioInstance;

  // Get All Users
  Future<List<UserModel>> getUser() async {
    final response = await _dio.get(NetworkAPI.users);
    if (response.statusCode == 200) {
      // logger.d(response.data);
      final List<UserModel> users =userModelFromJson(json.encode(response.data));
      return users;
    } 
    throw Exception('Error'); 
  }
}
