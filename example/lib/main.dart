import 'package:flutter/material.dart';
import 'dart:async';

import 'package:passage_flutter/passage_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _token = 'Waiting for auth event...';
  final _passageFlutterPlugin = PassageFlutter();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String token;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      final authResult = await _passageFlutterPlugin
          .register("ricky.padilla+example@passage.id");
      token = authResult?.authToken ?? 'Problem getting token';
    } on Exception catch (e) {
      // Anything else that is an exception
      print('$e');
      token = 'Problem getting token';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Passage Example App'),
          backgroundColor: const Color(0xff3D53F6),
        ),
        body: Center(
          child: Text('Auth token: $_token\n'),
        ),
      ),
    );
  }
}
