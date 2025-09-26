## 0.1.0

* Use `jni` and `jnigen` instead of method channels
    * Due to this more methods are now synchronous
* Add more properties to `PackageInfo` and use `DateTime` when applicable
* Add `getIcon` and `getIconFromApk` method
* The method `getPackageNameFromApk` is now called `getAppInfoFromApk` and returns `PackageInfo`

## 0.0.1

* Add install APK method
* Add uninstall app method
* Add get app info methods
* Add launch app method
