import 'package:rental_car/features/checkin/domain/entities/docuseal_contract_entity.dart';

class DocuSealContractModel extends DocuSealContractEntity {
  const DocuSealContractModel({
    required super.rentalId,
    required super.contractId,
    required super.contractCode,
    required super.contractStatus,
    required super.signingUrl,
    super.slug,
  });

  factory DocuSealContractModel.fromJson(Map<String, dynamic> json) {
    return DocuSealContractModel(
      rentalId: json['rentalId'] as int? ?? 0,
      contractId: json['contractId'] as int? ?? json['id'] as int? ?? 0,
      contractCode: json['contractCode'] as String? ?? '',
      contractStatus:
          (json['contractStatus'] as String?)?.toUpperCase() ??
          'PENDING_SIGNATURE',
      signingUrl:
          json['signingUrl'] as String? ?? json['signing_url'] as String? ?? '',
      slug: json['slug'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'rentalId': rentalId,
    'contractId': contractId,
    'contractCode': contractCode,
    'contractStatus': contractStatus,
    'signingUrl': signingUrl,
    'slug': slug,
  };
}

class ContractConfirmResultModel extends ContractConfirmResultEntity {
  const ContractConfirmResultModel({
    required super.rentalId,
    required super.status,
    required super.contractStatus,
    super.activatedAt,
  });

  factory ContractConfirmResultModel.fromJson(Map<String, dynamic> json) {
    return ContractConfirmResultModel(
      rentalId: json['rentalId'] as int? ?? 0,
      status: (json['status'] as String?)?.toUpperCase() ?? 'ACTIVE',
      contractStatus:
          (json['contractStatus'] as String?)?.toUpperCase() ?? 'SIGNED',
      activatedAt: json['activatedAt'] != null
          ? DateTime.tryParse(json['activatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'rentalId': rentalId,
    'status': status,
    'contractStatus': contractStatus,
    'activatedAt': activatedAt?.toIso8601String(),
  };
}
