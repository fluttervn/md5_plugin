import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:md5_plugin/md5_plugin.dart';

void main() {
  var channel = MethodChannel('md5_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return 'M78Wt4LB0sUBb+LcR8HfRg==';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getMD5WithPathOnAndroid', () async {
    expect(
        await Md5Plugin.getMD5WithPath(
            '/data/user/0/com.fluttervn.md5_plugin_example/app_flutter/image.jpg'),
        'M78Wt4LB0sUBb+LcR8HfRg==');
  });
  test('getMD5WithPathOniOS', () async {
    expect(
        await Md5Plugin.getMD5WithPath(
            '/var/mobile/Containers/Data/Application/7720FD4E-A452-4836-BFDA-64E3A735FD30/Documents/image.jpg'),
        'M78Wt4LB0sUBb+LcR8HfRg==');
  });
}
