Install and manage apps on Android devices.

> This plugin is still in development, use with caution as the API might change in upcoming versions.

## Features

Use this plugin in your Flutter Android App to:

* Install APKs
* Uninstall installed apps
* Get app info from installed apps or APKs
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

### Getting the package name from an APK

To extract the package name from an APK file:

```dart
final packageName = await ApkManager.getPackageNameFromApk('/path/to/file.apk');
```

### Getting app information

You can retrieve information about an installed app using its package name:

```dart
final info = await ApkManager.getAppInfo('com.example.app');
if (info != null) {
  print('App version: ${info.versionName}');
}
```

### Checking if an app is installed

To check if a specific package is currently installed:

```dart
final isInstalled = await ApkManager.isAppInstalled('com.example.app');
```

### Checking if an APK is installed

To check if an APK file corresponds to an installed app:

```dart
final isInstalled = await ApkManager.isApkInstalled('/path/to/file.apk');
```

### Launching an app

You can launch an installed app using its package name:

```dart
final success = await ApkManager.launchApp('com.example.app');
```
