import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apk_manager/apk_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PackageInfo? _platformVersion;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    PackageInfo? platformVersion;
    try {
      platformVersion = await ApkManager.getAppInfo("com.wearetoni.apk_manager_example");
    } on PlatformException {
      platformVersion = null;
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('APK Manager Example App'),
        ),
        body: Center(
          child: Text(
            switch (_platformVersion) {
              null => "Version not found",
              final version => "Version:\n${version.packageName}\n${version.versionName}\n(${version.installTime})",
            },
          ),
        ),
      ),
    );
  }
}
