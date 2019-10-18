import 'dart:async';

import 'package:flutter/services.dart';

class Md5Plugin {
  static const MethodChannel _channel = MethodChannel('md5_plugin');

  static Future<String> getMD5WithPath(String filePath) async {
    var map = {
      'file_path': filePath,
    };
    var checksum = await _channel.invokeMethod<String>('getMD5', map);
    return checksum;
  }
}
