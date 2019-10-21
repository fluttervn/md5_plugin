[![Build Status](https://travis-ci.org/fluttervn/md5_plugin.svg?branch=master)](https://travis-ci.org/fluttervn/md5_plugin)[![Pub](https://img.shields.io/pub/v/md5_plugin)](https://pub.dev/packages/md5_plugin)
# md5_plugin

A Flutter plugin for getting the MD5 hash of the file. It's faster when compared with using the crypto package (https://pub.dev/packages/crypto).
You can check the difference in my example.

## Usage

With my plugin:
```dart
Future<String> calculateMD5SumAsyncWithPlugin(String filePath) async {
    var ret = '';
    var file = File(filePath);
    if (await file.exists()) {
      try {
        ret = await Md5Plugin.getMD5WithPath(filePath);
      } catch (exception) {
        print('Unable to evaluate the MD5 sum :$exception');
        return null;
      }
    } else {
      print('`$filePath` does not exits so unable to evaluate its MD5 sum.');
      return null;
    }
    return ret;
  }
```

With crypto package:
```dart
Future<String> calculateMD5SumAsyncWithCrypto(String filePath) async {
    var ret = '';
    var file = File(filePath);
    if (await file.exists()) {
      try {
        var md5 = crypto.md5;
        var hash = await md5.bind(file.openRead()).first;
        ret = base64.encode(hash.bytes);
      } catch (exception) {
        print('Unable to evaluate the MD5 sum :$exception');
        return null;
      }
    } else {
      print('`$filePath` does not exits so unable to evaluate its MD5 sum.');
      return null;
    }
    return ret;
  }
```
And the result:

![demo](screenshots/demo.png)

## Authors
- [anlam87](https://github.com/anlam87) (anlam12787@gmail.com)
