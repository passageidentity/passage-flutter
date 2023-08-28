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
  String _content = '';
  final _passage = PassageFlutter();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String content;
    try {
      // ---------------------------------------------------
      // Use this space as a dev playground for Passage SDK.
      // ---------------------------------------------------
      content = 'Running integration tests...';
    } catch (e) {
      content = '';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _content = content;
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
          child: Text('Content: $_content\n'),
        ),
      ),
    );
  }
}
