// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Container(
          width: 300.0,
          height: 300.0,
          // color: Colors.red,
          decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(width: 5, color: Colors.black),
              // borderRadius: BorderRadius.circular(20),
              shape: BoxShape.circle,
              // image: const DecorationImage(
              //     image: NetworkImage(
              //         'https://www.nicepng.com/png/detail/301-3017371_tiger-logo-png-hd.png'),
              //     fit: BoxFit.cover),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFDD0B39),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Text("Text 1"),
                      IconButton(
                          onPressed: () {
                            print("Press 1");
                          },
                          icon: Icon(Icons.circle)),
                      IconButton(
                          onPressed: () {
                            print("Press 2");
                          },
                          icon: Icon(Icons.mood)),
                      IconButton(
                          onPressed: () {
                            print("Press 3");
                          },
                          icon: Icon(Icons.mood_bad)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.star)),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.motorcycle)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.biotech)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.hearing)),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.heart_broken)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.logo_dev)),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
