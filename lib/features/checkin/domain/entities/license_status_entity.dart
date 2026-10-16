class LicenseStatusEntity {
  const LicenseStatusEntity({
    required this.userId,
    required this.licenseStatus,
    this.licenseNumber,
    this.licenseExpiryDate,
    this.rejectReason,
  });

  final int userId;
  final String licenseStatus; // APPROVED | PENDING | REJECTED | NOT_SUBMITTED
  final String? licenseNumber;
  final String? licenseExpiryDate;
  final String? rejectReason;

  bool get isApproved => licenseStatus.toUpperCase() == 'APPROVED';
  bool get isPending => licenseStatus.toUpperCase() == 'PENDING';
  bool get isRejected => licenseStatus.toUpperCase() == 'REJECTED';
  bool get isNotSubmitted =>
      licenseStatus.toUpperCase() == 'NOT_SUBMITTED' ||
      licenseStatus.toUpperCase() == 'NONE';
}
