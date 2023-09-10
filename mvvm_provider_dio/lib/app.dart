import 'package:flutter/material.dart';
import 'package:mvvm_provider_dio/app_router.dart';
import 'package:mvvm_provider_dio/providers/bottomnav_provider.dart';
import 'package:mvvm_provider_dio/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

// Logger instance
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    colors: true,
    printEmojis: true,
    printTime: false
  ),
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BottomNavProvider()
        ),
        ChangeNotifierProvider(
          create: (_) => UserViewModel()
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MVVM Provider Dio',
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        initialRoute: AppRouter.home,
        routes: AppRouter.routes,
      ),
    );
  }
}