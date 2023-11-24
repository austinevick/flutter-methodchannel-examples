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
  final platform = const MethodChannel("samples.flutter.dev/counter");
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

  Future<void> preventScreenShot() async {
    try {
      if (isEnabled) {
        await platform.invokeMethod<bool>('disable');
        setState(() => isEnabled = false);
      } else {
        await platform.invokeMethod<bool>('enable');
        setState(() => isEnabled = true);
      }
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform code test'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SwitchListTile(
            value: isEnabled,
            onChanged: (val) {
              preventScreenShot();
              setState(() => isEnabled = val);
            },
            title: Text('${isEnabled ? "DISABLE" : "ENABLE"} SCREENSHOT'),
          ),
          Text(
            counter.toString(),
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () => increment(), child: const Text('INCREMENT')),
              TextButton(
                  onPressed: () => decrement(), child: const Text('DECREMENT'))
            ],
          )
        ],
      ),
    );
  }
}
