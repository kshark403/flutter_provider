import 'package:flutter/material.dart';
import 'package:flutter_provider/provider/counter_provider.dart';
import 'package:flutter_provider/provider/timer_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // provider
    // final provider = Provider.of<CounterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home (' + DateTime.now().microsecond.toString() + ")"),
        actions: [
          Consumer<TimerProvider>(builder: (context, provider, child) {
            return TextButton(
              onPressed: () {},
              child: Text(
                provider.seconds.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            );
          })
        ],
      ),
      body: Center(
        child: Consumer<CounterProvider>(
          builder: (context, provider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: provider.counterUp,
                  child: const Text('+ Up'),
                ),
                Text(
                  provider.counter.toString(),
                  style: TextStyle(fontSize: 50),
                ),
                ElevatedButton(
                  onPressed: provider.counterDown,
                  child: const Text('- Down'),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton:
          Consumer<TimerProvider>(builder: (context, provider, child) {
        return FloatingActionButton(
          onPressed: () =>
              provider.isRunning ? provider.stopTimer() : provider.startTimer(),
          child: Icon(provider.isRunning ? Icons.pause : Icons.play_arrow),
        );
      }),
    );
  }
}
