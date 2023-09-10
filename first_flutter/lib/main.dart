import 'package:first_flutter/routers/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.lightBlue,
          fontFamily: 'IBMPlexSanSThai',
        ),
        initialRoute: '/',
        routes: AppRouter.routes);
  }
}
