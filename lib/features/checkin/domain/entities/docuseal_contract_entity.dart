class DocuSealContractEntity {
  const DocuSealContractEntity({
    required this.rentalId,
    required this.contractId,
    required this.contractCode,
    required this.contractStatus,
    required this.signingUrl,
    this.slug,
  });

  final int rentalId;
  final int contractId;
  final String contractCode;
  final String contractStatus; // PENDING_SIGNATURE | SIGNED | EXPIRED
  final String signingUrl;
  final String? slug;

  bool get isSigned => contractStatus.toUpperCase() == 'SIGNED';
  bool get isPending =>
      contractStatus.toUpperCase() == 'PENDING_SIGNATURE' ||
      contractStatus.toUpperCase() == 'PENDING';
}

class ContractConfirmResultEntity {
  const ContractConfirmResultEntity({
    required this.rentalId,
    required this.status,
    required this.contractStatus,
    this.activatedAt,
  });

  final int rentalId;
  final String status; // ACTIVE
  final String contractStatus; // SIGNED
  final DateTime? activatedAt;

  bool get isActive => status.toUpperCase() == 'ACTIVE';
}
