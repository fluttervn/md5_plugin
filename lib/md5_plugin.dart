import 'dart:async';

import 'package:flutter/services.dart';

///Plugin class for getting MD5 String from Platform Channel.
class Md5Plugin {
  static const MethodChannel _channel = MethodChannel('md5_plugin');

  ///Method to get MD5 String
  ///- [filePath] : path of local file
  static Future<String?> getMD5WithPath(String filePath) async {
    var map = {
      'file_path': filePath,
    };
    var checksum = await _channel.invokeMethod<String>('getMD5', map);
    return checksum;
  }
}
