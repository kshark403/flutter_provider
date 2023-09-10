// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mvvm_provider_dio/providers/bottomnav_provider.dart';
import 'package:mvvm_provider_dio/services/user_api_service.dart';
import 'package:mvvm_provider_dio/views/bottomnav/map_screen.dart';
import 'package:mvvm_provider_dio/views/bottomnav/product_screen.dart';
import 'package:mvvm_provider_dio/views/bottomnav/user_screen.dart';
import 'package:mvvm_provider_dio/views/home/custom_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // bottom navigation screen
  var currentTab = [
    UserScreen(),
    ProductScreen(),
    MapScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Test Call API
    UserApiService().getUser();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<BottomNavProvider>(
          builder: (context, provider, child){
            return Text(provider.title);
          },
        )
      ),
      body: Consumer<BottomNavProvider>(
          builder: (context, provider, child){
          return currentTab[provider.currentIndex];
        },
      ),
      bottomNavigationBar: Consumer<BottomNavProvider>(
        builder: (context, provider, child){
          return BottomNavigationBar(
            currentIndex: provider.currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              provider.updateIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Users'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.storefront),
                label: 'Products'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Maps'
              ),
            ]
          );
        },
      ),
    );
  }
}