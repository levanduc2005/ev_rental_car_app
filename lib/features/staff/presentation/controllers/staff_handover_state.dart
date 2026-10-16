import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/checkin/presentation/controllers/checkin_state.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';

enum StaffHandoverStep {
  reservationCheck, // Bước 1: Kiểm tra đơn & tạo rental
  contractSigning, // Bước 2: Ký hợp đồng DocuSeal
  payment, // Bước 3: Thanh toán tiền thuê + cọc còn lại
  inspection, // Bước 4: Chụp ảnh ngoại quan & kiểm tra xe
  completed, // Bước 5: Bàn giao xe hoàn tất (ONGOING)
}

class StaffHandoverState {
  const StaffHandoverState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.currentStep = StaffHandoverStep.reservationCheck,
    this.reservation,
    this.rental,
    this.contractUrl,
    this.isContractSigned = false,
    this.paymentUrl,
    this.isPaymentConfirmed = false,
    this.payosPaymentInfo,
    this.paymentMethod = 'CASH',
    this.isGeneratingPayOS = false,
    this.photos = const [],
    this.isUploadingPhoto = false,
    this.batteryPercentage = 95,
    this.odometer,
    this.note = '',
  });

  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final StaffHandoverStep currentStep;

  final ReservationEntity? reservation;
  final RentalDetailEntity? rental;

  // Hợp đồng
  final String? contractUrl;
  final bool isContractSigned;

  // Thanh toán
  final String? paymentUrl;
  final bool isPaymentConfirmed;
  final PayOSPaymentInfoEntity? payosPaymentInfo;
  final String paymentMethod; // 'CASH' hoặc 'PAYOS'
  final bool isGeneratingPayOS;

  // Biên bản kiểm tra xe
  final List<CheckInPhoto> photos;
  final bool isUploadingPhoto;
  final int batteryPercentage;
  final int? odometer;
  final String note;

  bool get hasPhotos => photos.any((p) => p.isUploaded);

  bool get isInspectionValid =>
      hasPhotos &&
      batteryPercentage > 0 &&
      batteryPercentage <= 100 &&
      (odometer != null ? odometer! > 0 : true);

  StaffHandoverState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? Function()? errorMessage,
    StaffHandoverStep? currentStep,
    ReservationEntity? reservation,
    RentalDetailEntity? rental,
    String? Function()? contractUrl,
    bool? isContractSigned,
    String? Function()? paymentUrl,
    bool? isPaymentConfirmed,
    PayOSPaymentInfoEntity? Function()? payosPaymentInfo,
    String? paymentMethod,
    bool? isGeneratingPayOS,
    List<CheckInPhoto>? photos,
    bool? isUploadingPhoto,
    int? batteryPercentage,
    int? Function()? odometer,
    String? note,
  }) {
    return StaffHandoverState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      currentStep: currentStep ?? this.currentStep,
      reservation: reservation ?? this.reservation,
      rental: rental ?? this.rental,
      contractUrl: contractUrl != null ? contractUrl() : this.contractUrl,
      isContractSigned: isContractSigned ?? this.isContractSigned,
      paymentUrl: paymentUrl != null ? paymentUrl() : this.paymentUrl,
      isPaymentConfirmed: isPaymentConfirmed ?? this.isPaymentConfirmed,
      payosPaymentInfo: payosPaymentInfo != null
          ? payosPaymentInfo()
          : this.payosPaymentInfo,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isGeneratingPayOS: isGeneratingPayOS ?? this.isGeneratingPayOS,
      photos: photos ?? this.photos,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      batteryPercentage: batteryPercentage ?? this.batteryPercentage,
      odometer: odometer != null ? odometer() : this.odometer,
      note: note ?? this.note,
    );
  }
}
