Install and manage apps on Android devices.

> This plugin is still in development, use with caution as the API might change in upcoming versions.

## Features

Use this plugin in your Flutter Android App to:

* Install APKs
* Uninstall installed apps
* Get app info from installed apps or APKs
* Get app icons from installed apps or APKs
* Launch installed apps

## Getting started

This plugin uses the Android system APIs, most API calls need their respective permission to be granted.

Declare them in your `AndroidManifest.xml` like this:

```xml
<uses-permission android:name="android.permission.REQUEST_DELETE_PACKAGES"/>
<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

## Usage

The plugin does not need to be initialized and can be used directly by calling the static methods of the `ApkManager` class.

Some calls need their respective permissions to be granted, use a plugin like `permission_handler` to check and request permissions.

```dart
final permission = Permission.requestInstallPackages;
if ((await permission.status).isDenied) {
  await permission.request();
}
```

Once the permissions are granted you start using the respective static methods.

### Installing an APK

To install an APK, use the `installApk` method. A system dialog will be shown to confirm the installation.

```dart
final result = await ApkManager.installApk(path: '/path/to/file.apk');
```

### Uninstalling an app

You can uninstall an app using the `uninstallApp` method by providing the app’s package name. A system dialog will be shown to confirm the uninstallation.

```dart
await ApkManager.uninstallApp('com.example.app');
```

> Due to limitations of the uninstall api it's currently not possible to detect when the user cancels the uninstall in the system dialog.

### Getting app information

You can retrieve information about an installed app using its package name:

```dart
final info = ApkManager.getAppInfo('com.example.app');
if (info != null) {
  print('App version: ${info.versionName}');
}
```

### Getting app information from an APK

You can retrieve information about an APK file:

```dart
final info = ApkManager.getAppInfoFromApk('/path/to/file.apk');
if (info != null) {
  print('App version: ${info.versionName}');
}
```

### Getting app icon

You can retrieve the icon of an installed app as raw bytes:

```dart
final iconBytes = ApkManager.getIcon('com.example.app');
```

### Getting icon from APK file

You can retrieve the icon from an APK file without installing it:

```dart
final iconBytes = ApkManager.getIconFromApk('/path/to/file.apk');
```

### Checking if an app is installed

To check if a specific package is currently installed:

```dart
final isInstalled = ApkManager.isAppInstalled('com.example.app');
```

### Checking if an APK is installed

To check if an APK file corresponds to an installed app:

```dart
final isInstalled = ApkManager.isApkInstalled('/path/to/file.apk');
```

### Launching an app

You can launch an installed app using its package name:

```dart
final success = ApkManager.launchApp('com.example.app');
```

### Getting all installed apps

You can retrieve a list of all installed apps on the device:

```dart
final installedApps = ApkManager.getInstalledApps();
if (installedApps != null) {
  for (final app in installedApps) {
    print('${app.appName} (${app.packageName}) - Version: ${app.versionName}');
  }
}
```
