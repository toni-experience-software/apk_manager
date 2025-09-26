import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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
  DateTime? installTime;
  Uint8List? appIcon;
  List<PackageInfo>? installedApps;
  bool isLoadingApps = false;

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
      getAppInfo();
    }
  }

  void getApkPackageName() async {
    if (selectedFile case final path?) {
      final res = ApkManager.getAppInfoFromApk(path);
      if (res != null) {
        final icon = ApkManager.getIconFromApk(path);
        setState(() {
          packageName = res.packageName;
          appIcon = icon;
        });
      }
    }
  }

  void getAppInfo() {
    if (packageName case final pkg?) {
      final res = ApkManager.getAppInfo(pkg);
      final icon = ApkManager.getIcon(pkg);
      setState(() {
        installTime = res?.installTime;
        installed = res != null;
        appIcon = icon;
      });
    }
  }

  void launchApp() {
    if (packageName case final pkg?) {
      final res = ApkManager.launchApp(pkg);
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
        appIcon = null;
      });
      // Refresh the installed apps list after uninstalling
      loadInstalledApps();
    }
  }

  Future<void> loadInstalledApps() async {
    setState(() {
      isLoadingApps = true;
    });

    try {
      final apps = ApkManager.getInstalledApps();
      setState(() {
        installedApps = apps;
        isLoadingApps = false;
      });
    } catch (e) {
      setState(() {
        isLoadingApps = false;
      });
      // Handle error silently or show user-friendly message
      debugPrint('Error loading installed apps: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Load installed apps when the app starts
    loadInstalledApps();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('APK Manager Example App'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'APK Manager', icon: Icon(Icons.android)),
                Tab(text: 'Installed Apps', icon: Icon(Icons.apps)),
              ],
            ),
          ),
          body: TabBarView(
            children: [_buildApkManagerTab(), _buildInstalledAppsTab()],
          ),
        ),
      ),
    );
  }

  Widget _buildApkManagerTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 8,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(switch (selectedFile) {
                    null => "No file selected",
                    final file => file,
                  }),
                ),
                IconButton(icon: Icon(Icons.file_open), onPressed: selectFile),
              ],
            ),
            if (selectedFile != null) ...[
              MaterialButton(onPressed: installApp, child: Text("Install APK")),
            ],
            Row(
              spacing: 8,
              children: [
                if (appIcon case final icon?) ...[Image.memory(icon)],
                Expanded(
                  child: Column(
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
                        Text("Install Time: $time"),
                      ],
                    ],
                  ),
                ),
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
                      () =>
                          requestPermission(Permission.requestInstallPackages),
                  child: Text("Install Permission"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstalledAppsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Installed Apps',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: loadInstalledApps,
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),
        Expanded(
          child:
              isLoadingApps
                  ? const Center(child: CircularProgressIndicator())
                  : installedApps == null || installedApps!.isEmpty
                  ? const Center(child: Text('No installed apps found'))
                  : ListView.builder(
                    itemCount: installedApps!.length,
                    itemBuilder: (context, index) {
                      final app = installedApps![index];
                      final icon = ApkManager.getIcon(app.packageName);

                      return ListTile(
                        leading:
                            icon != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    icon,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : const Icon(Icons.android, size: 48),
                        title: Text(
                          app.name?.isNotEmpty == true
                              ? app.name!
                              : app.packageName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Package: ${app.packageName}'),
                            Text(
                              'Version: ${app.versionName ?? 'Unknown'} (${app.versionCode})',
                            ),
                            Text(
                              'Installed: ${app.installTime.toLocal().toString().split('.')[0]}',
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'launch':
                                ApkManager.launchApp(app.packageName);
                                break;
                              case 'uninstall':
                                _showUninstallDialog(app);
                                break;
                            }
                          },
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: 'launch',
                                  child: Row(
                                    children: [
                                      Icon(Icons.launch),
                                      SizedBox(width: 8),
                                      Text('Launch'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'uninstall',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete),
                                      SizedBox(width: 8),
                                      Text('Uninstall'),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
        ),
      ],
    );
  }

  void _showUninstallDialog(PackageInfo app) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Uninstall ${app.name?.isNotEmpty == true ? app.name! : app.packageName}',
            ),
            content: Text('Are you sure you want to uninstall this app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await ApkManager.uninstallApp(app.packageName);
                  loadInstalledApps(); // Refresh the list
                },
                child: Text('Uninstall'),
              ),
            ],
          ),
    );
  }
}
