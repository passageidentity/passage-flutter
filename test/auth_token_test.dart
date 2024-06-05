import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter_web.dart';



void main() {
  group('AuthToken validation', () {
    final passageFlutterWeb = PassageFlutterWeb();

    test('Valid token should return true', () async {
      // Token with an expiration time in the future (e.g., Dec 31, 2024)
      const validToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzU2ODk2MDB9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';
      final result = await passageFlutterWeb.isAuthTokenValid(validToken);
      expect(result, true);
    });

    test('Invalid token should return false', () async {
      // Token with an expiration time in the past (e.g., Dec 31, 2020)
      const invalidToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDk4NTY4MDB9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

      final result = await passageFlutterWeb.isAuthTokenValid(invalidToken);
      expect(result, false);
    });

    test('Malformed token should return false', () async {
      // Token with an incorrect format
      const malformedToken = 'this.is.not.a.valid.token';

      final result = await passageFlutterWeb.isAuthTokenValid(malformedToken);
      expect(result, false);
    });
  });
}
