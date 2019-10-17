import 'dart:async';

import 'package:flutter/services.dart';

class Md5Plugin {
  static const MethodChannel _channel = const MethodChannel('md5_plugin');

  static Future<String> getMD5WithPath(filePath) async {
    Map<String, String> map = {
      "file_path": filePath,
    };
    final String checksum = await _channel.invokeMethod('getMD5', map);
    return checksum;
  }
}
