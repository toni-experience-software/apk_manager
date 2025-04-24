enum ApkInstallStatus {
  success(0),
  failure(1),
  failureBlocked(2),
  failureAborted(3),
  failureInvalid(4),
  failureConflict(5),
  failureStorage(6),
  failureIncompatible(7),
  unknown(-2);

  const ApkInstallStatus(this.code);

  final int code;

  ///Get enum type by status code
  static ApkInstallStatus byCode(int? code) =>
      ApkInstallStatus.values.firstWhere(
        (e) => e.code == code,
        orElse: () => ApkInstallStatus.unknown,
      );
}
