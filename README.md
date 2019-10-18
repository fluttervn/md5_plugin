[![Build Status](https://travis-ci.org/fluttervn/md5_plugin.svg?branch=master)](https://travis-ci.org/fluttervn/md5_plugin)
# md5_plugin

A Flutter plugin for getting the MD5 hash of the file.

## Usage
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
## Authors
- [anlam87](https://github.com/anlam87) (anlam12787@gmail.com)



