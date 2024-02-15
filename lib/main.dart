import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final platform = const MethodChannel("com.example.mysample/methodchannel");

  bool isEnabled = true;
  int counter = 0;

  Future<void> increment() async {
    try {
      final result = await platform.invokeMethod<int>('increment');
      setState(() {
        counter = result!;
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> decrement() async {
    try {
      final result = await platform.invokeMethod<int>('decrement');
      setState(() {
        counter = result!;
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void turnOnFlashLight() async => await platform.invokeMethod('turnOnTorch');
  void turnOffFlashLight() async => await platform.invokeMethod('turnOffTorch');
  void showToast() async => await platform
      .invokeMethod('showToast', {'msg': 'This is a toast message', 'dur': 1});

  Future<void> preventScreenShot() async {
    try {
      if (isEnabled) {
        await platform.invokeMethod<bool>('disableScreenshot');
        setState(() => isEnabled = false);
      } else {
        await platform.invokeMethod<bool>('enableScreenshot');
        setState(() => isEnabled = true);
      }
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 18);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'A collection of MethodChannel examples',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('Screen shot', style: style),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: isEnabled,
              onChanged: (val) {
                preventScreenShot();
                setState(() => isEnabled = val);
              },
              title: Text('${isEnabled ? "DISABLE" : "ENABLE"} SCREENSHOT'),
            ),
            const Text('Counter app', style: style),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                    onPressed: () => increment(),
                    child: const Text('INCREMENT')),
                Text(
                  counter.toString(),
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.bold),
                ),
                OutlinedButton(
                    onPressed: () => decrement(),
                    child: const Text('DECREMENT'))
              ],
            ),
            const Text('Flash Light', style: style),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                    onPressed: () => turnOnFlashLight(),
                    child: const Text('TURN ON')),
                OutlinedButton(
                    onPressed: () => turnOffFlashLight(),
                    child: const Text('TURN OFF'))
              ],
            ),
            const Text('Toast', style: style),
            OutlinedButton(
                onPressed: () => showToast(), child: const Text('SHOW')),
          ],
        ),
      ),
    );
  }
}
