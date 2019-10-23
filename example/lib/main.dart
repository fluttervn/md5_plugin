import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:md5_plugin/md5_plugin.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

///Root class for starting application
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _md5SumPlugin = 'Unknown';
  String _md5SumDart = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String md5SumPlugin;
    String md5SumDartCrypto;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      //Prepare image
      var directory = await getApplicationDocumentsDirectory();
      var dbPath = join(directory.path, 'image1.jpg');
      var data = await rootBundle.load('assets/image1.jpg');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
      print('path: $dbPath');

      //Get md5 sum from Crypto
      var date = DateTime.now();
      md5SumDartCrypto = await calculateMD5SumAsyncWithCrypto(dbPath);
      print('md5SumDartCrypto: $md5SumDartCrypto');
      md5SumDartCrypto +=
          ' - duration: ${DateTime.now().difference(date).inMilliseconds}';

      //Get md5 sum from Plugin
      date = DateTime.now();
      md5SumPlugin = await calculateMD5SumAsyncWithPlugin(dbPath);
      print('md5SumPlugin: $md5SumPlugin');
      md5SumPlugin +=
          ' - duration: ${DateTime.now().difference(date).inMilliseconds}';
    } on PlatformException {
      md5SumPlugin = 'Failed to get md5 from Plugin';
      md5SumDartCrypto = 'Failed to get md5 from Crypto';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _md5SumPlugin = md5SumPlugin;
      _md5SumDart = md5SumDartCrypto;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Container(
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('MD5 Plugin: $_md5SumPlugin\n'),
                Text('MD5 Crypto: $_md5SumDart\n'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
