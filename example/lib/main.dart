import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:passage_flutter/passage_flutter.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error_code.dart';

// ----------------------------------------------------------------------------------------
//
// For a FULL example app, please visit: https://github.com/passageidentity/example-flutter
//
// ----------------------------------------------------------------------------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _passage = PassageFlutter();
  final _controller = TextEditingController();
  bool _isNewUser = false;

  void _register(String identifier) async {
    try {
      await _passage.register(identifier);
      final user = await _passage.getCurrentUser();
      if (user != null) {
        debugPrint('authenticated user id: ${user.id}');
      }
    } catch (error) {
      if (error is PassageError &&
          error.code == PassageErrorCode.userCancelled) {
        // User cancelled passkey prompt, do nothing.
      } else if (identifier.isNotEmpty) {
        debugPrint(error.toString());
        // Try using a fallback authentication method instead.
        // See full example app for example fallback auth:
        // https://github.com/passageidentity/example-flutter
      }
    }
  }

  void _login(String identifier) async {
    try {
      if (kIsWeb) {
        await _passage.loginWithIdentifier(identifier);
      } else {
        await _passage.login();
      }
      final user = await _passage.getCurrentUser();
      if (user != null) {
        debugPrint('authenticated user id: ${user.id}');
      }
    } catch (error) {
      if (error is PassageError &&
          error.code == PassageErrorCode.userCancelled) {
        // User cancelled passkey prompt, do nothing.
      } else if (identifier.isNotEmpty) {
        debugPrint(error.toString());
        // Try using a fallback authentication method instead.
        // See full example app for example fallback auth:
        // https://github.com/passageidentity/example-flutter
      }
    }
  }

  void _toggleIsNewUser() {
    setState(() {
      _isNewUser = !_isNewUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final label = _isNewUser ? 'Register' : 'Login';
    final switchLabel = !_isNewUser
        ? 'Don\'t have an account? Register'
        : 'Already have an account? Log in';
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Passage Example App'),
          backgroundColor: const Color(0xff3D53F6),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 14, top: 32, right: 14),
            child: Column(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'example@passage.id',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 10.0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 400,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3D53F6),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (_isNewUser) {
                        _register(_controller.text);
                      } else {
                        _login(_controller.text);
                      }
                    },
                    child: Text(label),
                  ),
                ),
                const SizedBox(height: 6.0),
                TextButton(
                  onPressed: _toggleIsNewUser,
                  style: TextButton.styleFrom(
                      foregroundColor: const Color(0xff3D53F6)),
                  child: Text(switchLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
