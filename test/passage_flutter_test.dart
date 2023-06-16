import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'package:passage_flutter/passage_flutter_platform_interface.dart';
import 'package:passage_flutter/passage_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPassageFlutterPlatform
    with MockPlatformInterfaceMixin
    implements PassageFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PassageFlutterPlatform initialPlatform = PassageFlutterPlatform.instance;

  test('$MethodChannelPassageFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPassageFlutter>());
  });

  test('getPlatformVersion', () async {
    PassageFlutter passageFlutterPlugin = PassageFlutter();
    MockPassageFlutterPlatform fakePlatform = MockPassageFlutterPlatform();
    PassageFlutterPlatform.instance = fakePlatform;

    expect(await passageFlutterPlugin.getPlatformVersion(), '42');
  });
}
