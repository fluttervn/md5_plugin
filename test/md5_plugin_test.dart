import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:md5_plugin/md5_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('md5_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return 'GB5/4IQhXtnLZV0qg7bfBA==';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getMD5WithPath', () async {
    expect(
        await Md5Plugin.getMD5WithPath(
            '/var/mobile/Containers/Data/Application/DB160087-739F-4C5E-8DE8-402D796557F7/Documents/Download/IMG_0295.JPG'),
        'GB5/4IQhXtnLZV0qg7bfBA==');
  });
}
