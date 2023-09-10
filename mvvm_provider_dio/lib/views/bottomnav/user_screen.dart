// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:mvvm_provider_dio/app_router.dart';
import 'package:mvvm_provider_dio/constants/network_api.dart';
import 'package:mvvm_provider_dio/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {

  // Create  UserViewModel instance
  late UserViewModel userViewModel;

  @override
  Widget build(BuildContext context) {

    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.fetchUser();

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        userViewModel.fetchUser();
      },
      child: Column(
        children: [
          Container(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'User Lists (${DateTime.now().microsecond.toString()})',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          Consumer<UserViewModel>(builder: (context, value, child) {
            final userList = value.users;
            return Expanded(
              child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        NetworkAPI.imageURL + '/profile/' + user.imgProfile.toString()
                      ),
                    ),
                    title: Text('ID: ${user.id}'),
                    subtitle: Text('Name: ${user.fullname}'),
                    onTap: () {
                      Navigator.pushNamed(
                        context, 
                        AppRouter.userdetail, 
                        arguments: {'user': user.toJson()}
                      );
                    }
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
