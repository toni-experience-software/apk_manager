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
  bool? installed;
  String? packageName;
  int? installTime;

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
        packageName = res.packageName;
      });
      await getAppInfo();
    }
  }

  Future<void> getApkPackageName() async {
    if (selectedFile case final path?) {
      final res = await ApkManager.getPackageNameFromApk(path);
      if (res != null) {
        setState(() => packageName = res);
      }
    }
  }

  Future<void> getAppInfo() async {
    if (packageName case final pkg?) {
      final res = await ApkManager.getAppInfo(pkg);
      setState(() {
        installTime = res?.installTime;
        installed = res != null;
      });
    }
  }

  Future<void> launchApp() async {
    if (packageName case final pkg?) {
      final res = await ApkManager.launchApp(pkg);
      setState(() => installed = res);
    }
  }

  Future<void> uninstallApp() async {
    if (packageName case final pkg?) {
      await ApkManager.uninstallApp(pkg);
      setState(() {
        installed = false;
        installTime = null;
        installResult = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('APK Manager Example App')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 8,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(switch (selectedFile) {
                        null => "No file selcted",
                        final file => file,
                      }),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (installResult case final result?) ...[
                      Text("Install Status: ${result.status}"),
                    ],
                    if (packageName case final packageName?) ...[
                      Text("Package Name: $packageName"),
                    ],
                    if (installed case final isInstalled?) ...[
                      Text("Installed: $isInstalled"),
                    ],
                    if (installTime case final time?) ...[
                      Text(
                        "Install Time: ${DateTime.fromMillisecondsSinceEpoch(time)}",
                      ),
                    ],
                  ],
                ),
                Divider(),
                if (selectedFile != null) ...[
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: getApkPackageName,
                        child: Text("Get Package Name"),
                      ),
                      MaterialButton(
                        onPressed: getAppInfo,
                        child: Text("Get App Info"),
                      ),
                      if (packageName != null && installed == true) ...[
                        MaterialButton(
                          onPressed: launchApp,
                          child: Text("Launch App"),
                        ),
                        MaterialButton(
                          onPressed: uninstallApp,
                          child: Text("Uninstall App"),
                        ),
                      ],
                    ],
                  ),
                ],
                Spacer(),
                Divider(),
                Text("Request Permissions:"),
                Wrap(
                  children: [
                    MaterialButton(
                      onPressed: () => requestPermission(Permission.storage),
                      child: Text("Storage Permission"),
                    ),
                    MaterialButton(
                      onPressed:
                          () => requestPermission(
                            Permission.requestInstallPackages,
                          ),
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
