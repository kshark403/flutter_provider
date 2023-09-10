// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:mvvm_provider_dio/constants/network_api.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Get user data from arguments
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(arguments['user']['fullname']),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(
                  NetworkAPI.imageURL +
                      '/profile/' +
                      arguments['user']['img_profile'].toString(),
                ),
              ),
              SizedBox(height: 16),
                Text(
                  '${'Username: ' + arguments['user']['username']}',
                  style: TextStyle(fontSize: 24),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
