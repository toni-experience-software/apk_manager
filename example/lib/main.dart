import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:apk_manager/apk_manager.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selectedFile;
  ApkInstallResult? installResult;

  Future<void> selectFile() async {
    final res = await FilePicker.platform.pickFiles();
    if (res?.files case [final file]) {
      setState(() {
        selectedFile = file.path;
      });
    }
  }

  Future<void> requestPermission(Permission permission) async {
    if ((await permission.status).isDenied) {
      await permission.request();
    }
  }

  Future<void> installApp() async {
    if (selectedFile case final path?) {
      final res = await ApkManager.installApk(path: path);
      setState(() {
        installResult = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('APK Manager Example App'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 8,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        switch (selectedFile) {
                          null => "No file selcted",
                          final file => file,
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.file_open),
                      onPressed: selectFile,
                    ),
                  ],
                ),
                if (selectedFile != null) ...[
                  MaterialButton(
                    onPressed: installApp,
                    child: Text("Install APK"),
                  ),
                ],
                if (installResult case final result?) ...[
                  Text("Install Status: ${result.status}"),
                  Text("Package Name: ${result.packageName}"),
                ],
                Spacer(),
                Text("Request Permissions:"),
                Wrap(
                  children: [
                    MaterialButton(
                      onPressed: () => requestPermission(Permission.storage),
                      child: Text("Storage Permission"),
                    ),
                    MaterialButton(
                      onPressed: () => requestPermission(Permission.requestInstallPackages),
                      child: Text("Install Permission"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
