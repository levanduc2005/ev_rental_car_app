import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';
import 'package:rental_car/features/checkin/domain/usecases/upload_car_image_usecase.dart';
import 'package:rental_car/features/checkin/presentation/providers/checkin_controller.dart';
import 'package:rental_car/features/checkin/presentation/providers/checkin_providers.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/domain/usecases/cancel_staff_rental_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/convert_reservation_to_rental_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/generate_staff_contract_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/get_checkin_payment_url_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/submit_staff_checklist_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/update_rental_status_usecase.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';

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

class StaffHandoverController extends Notifier<StaffHandoverState> {
  ConvertReservationToRentalUseCase? _injectedConvertUseCase;
  GenerateStaffContractUseCase? _injectedContractUseCase;
  GetCheckInPaymentUrlUseCase? _injectedPaymentUseCase;
  UpdateRentalStatusUseCase? _injectedUpdateStatusUseCase;
  SubmitStaffCheckListUseCase? _injectedSubmitChecklistUseCase;
  UploadCarImageUseCase? _injectedUploadImageUseCase;
  CancelStaffRentalUseCase? _injectedCancelUseCase;
  ImagePicker? _injectedImagePicker;

  CancelStaffRentalUseCase get _cancelUseCase =>
      _injectedCancelUseCase ?? ref.read(cancelStaffRentalUseCaseProvider);

  ConvertReservationToRentalUseCase get _convertUseCase =>
      _injectedConvertUseCase ??
      ref.read(convertReservationToRentalUseCaseProvider);

  GenerateStaffContractUseCase get _contractUseCase =>
      _injectedContractUseCase ??
      ref.read(generateStaffContractUseCaseProvider);

  GetCheckInPaymentUrlUseCase get _paymentUseCase =>
      _injectedPaymentUseCase ?? ref.read(getCheckInPaymentUrlUseCaseProvider);

  UpdateRentalStatusUseCase get _updateStatusUseCase =>
      _injectedUpdateStatusUseCase ??
      ref.read(updateRentalStatusUseCaseProvider);

  SubmitStaffCheckListUseCase get _submitChecklistUseCase =>
      _injectedSubmitChecklistUseCase ??
      ref.read(submitStaffCheckListUseCaseProvider);

  UploadCarImageUseCase get _uploadImageUseCase =>
      _injectedUploadImageUseCase ?? ref.read(uploadCarImageUseCaseProvider);

  ImagePicker get _imagePicker => _injectedImagePicker ?? ImagePicker();

  void injectDependencies({
    ConvertReservationToRentalUseCase? convertUseCase,
    GenerateStaffContractUseCase? contractUseCase,
    GetCheckInPaymentUrlUseCase? paymentUseCase,
    UpdateRentalStatusUseCase? updateStatusUseCase,
    SubmitStaffCheckListUseCase? submitChecklistUseCase,
    UploadCarImageUseCase? uploadImageUseCase,
    CancelStaffRentalUseCase? cancelUseCase,
    ImagePicker? imagePicker,
  }) {
    _injectedConvertUseCase = convertUseCase;
    _injectedContractUseCase = contractUseCase;
    _injectedPaymentUseCase = paymentUseCase;
    _injectedUpdateStatusUseCase = updateStatusUseCase;
    _injectedSubmitChecklistUseCase = submitChecklistUseCase;
    _injectedUploadImageUseCase = uploadImageUseCase;
    _injectedCancelUseCase = cancelUseCase;
    _injectedImagePicker = imagePicker;
  }

  @override
  StaffHandoverState build() => const StaffHandoverState();

  void setup({ReservationEntity? reservation, RentalDetailEntity? rental}) {
    if (reservation != null) {
      state = state.copyWith(
        reservation: reservation,
        currentStep: StaffHandoverStep.reservationCheck,
      );
    } else if (rental != null) {
      StaffHandoverStep step = StaffHandoverStep.contractSigning;
      final status = rental.status.toUpperCase();
      final contractStatus = rental.contractStatus?.toUpperCase() ?? '';

      // Tự động phân tích bước tiến độ thực tế của đơn thuê
      if (status == 'ONGOING' || rental.checkInChecklist != null) {
        step = StaffHandoverStep.completed;
      } else if (status == 'CONFIRM' || status == 'DEPOSITED') {
        step = StaffHandoverStep.inspection;
      } else if (contractStatus == 'SIGNED') {
        step = StaffHandoverStep.payment;
      } else {
        step = StaffHandoverStep.contractSigning;
      }

      // Nếu người dùng lỡ bấm trở ra và quay lại đơn đang thao tác, giữ nguyên bước cao nhất đã tới
      if (state.rental?.id == rental.id &&
          state.currentStep.index > step.index) {
        step = state.currentStep;
      }

      final isContractSigned =
          contractStatus == 'SIGNED' ||
          step.index >= StaffHandoverStep.payment.index ||
          (state.rental?.id == rental.id && state.isContractSigned);

      final isPaymentConfirmed =
          status == 'CONFIRM' ||
          step.index >= StaffHandoverStep.inspection.index ||
          (state.rental?.id == rental.id && state.isPaymentConfirmed);

      state = state.copyWith(
        rental: rental,
        currentStep: step,
        contractUrl: () => rental.contractUrl ?? state.contractUrl,
        isContractSigned: isContractSigned,
        isPaymentConfirmed: isPaymentConfirmed,
        batteryPercentage:
            rental.currentBattery?.toInt() ?? state.batteryPercentage,
      );

      // Nếu đã ở bước payment hoặc inspection, sẵn sàng link thanh toán & mã QR
      if (step == StaffHandoverStep.payment ||
          step == StaffHandoverStep.inspection) {
        if (state.paymentUrl == null) {
          fetchPaymentUrl(rental.id);
        }
        if (state.payosPaymentInfo == null) {
          generatePayOSQr();
        }
      }
    }
  }

  /// Hủy đơn thuê xe và rollback trạng thái xe về sẵn sàng (AVAILABLE)
  Future<bool> cancelRental() async {
    final rentalId = state.rental?.id;
    if (rentalId == null || rentalId <= 0) {
      state = state.copyWith(
        errorMessage: () => 'Không tìm thấy thông tin đơn thuê để hủy.',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: () => null);

    final result = await _cancelUseCase(rentalId);

    return result.when(
      ok: (_) {
        state = state.copyWith(isSubmitting: false);
        return true;
      },
      err: (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
    );
  }

  /// Bước 1: Nhân viên bấm "Tiến hành nhận xe" -> Tạo Rental từ Reservation
  Future<bool> startHandover(int staffId) async {
    final res = state.reservation;
    if (res == null) return false;

    if (res.status.toUpperCase() == 'COMPLETED' ||
        res.status.toUpperCase() == 'DONE') {
      state = state.copyWith(
        errorMessage: () => 'Đơn đặt trước này đã hoàn tất bàn giao.',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: () => null);

    final result = await _convertUseCase(
      reservationCode: res.code,
      staffId: staffId,
    );

    return result.when(
      ok: (rental) async {
        state = state.copyWith(
          isSubmitting: false,
          rental: rental,
          currentStep: StaffHandoverStep.contractSigning,
        );
        // Tự động khởi tạo hợp đồng DocuSeal
        await requestContract(rental.id);
        return true;
      },
      err: (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
    );
  }

  /// Bước 2: Gọi API lấy link ký hợp đồng DocuSeal
  Future<bool> requestContract(int rentalId) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await _contractUseCase(rentalId);
    return result.when(
      ok: (url) {
        state = state.copyWith(isLoading: false, contractUrl: () => url);
        return true;
      },
      err: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
    );
  }

  /// Bước 2: Đánh dấu khách đã ký số hoàn tất -> Chuyển sang thanh toán Check-in
  Future<void> onContractSigned() async {
    state = state.copyWith(
      isContractSigned: true,
      currentStep: StaffHandoverStep.payment,
    );

    // Nạp link thanh toán VNPay và khởi tạo mã PayOS
    if (state.rental != null) {
      await fetchPaymentUrl(state.rental!.id);
    }
    await generatePayOSQr();
  }

  /// Bước 3: Lấy link thanh toán Check-in (tiền thuê + cọc xe còn lại)
  Future<void> fetchPaymentUrl(int rentalId) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final result = await _paymentUseCase(rentalId: rentalId);
    result.when(
      ok: (url) =>
          state = state.copyWith(isLoading: false, paymentUrl: () => url),
      err: (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: () => failure.message,
      ),
    );
  }

  /// Bước 3: Đổi phương thức thanh toán ('CASH' hoặc 'PAYOS')
  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
    if (method == 'PAYOS' && state.payosPaymentInfo == null) {
      generatePayOSQr();
    }
  }

  /// Bước 3: Tạo mã QR PayOS VietQR
  Future<void> generatePayOSQr() async {
    state = state.copyWith(isGeneratingPayOS: true, errorMessage: () => null);

    // 1. Thử gọi API backend tạo PayOS payment link nếu có reservation ID
    final resId = state.reservation?.id ?? 0;
    if (resId > 0) {
      final result = await ref
          .read(bookingRepositoryProvider)
          .createPayOSPaymentLink(resId);
      final handled = result.when<bool>(
        ok: (payos) {
          state = state.copyWith(
            isGeneratingPayOS: false,
            payosPaymentInfo: () => payos,
          );
          return true;
        },
        err: (_) => false,
      );
      if (handled) return;
    }

    // 2. Tạo mã VietQR PayOS động với số tiền thực tế
    final rentFee = state.rental?.rentFee ?? 0;
    final deposit = state.rental?.rentalDepositAmount ?? 0;
    final total = (rentFee + deposit).round();
    final cleanAmount = total > 0 ? total : 500000;
    final id =
        state.rental?.id ?? DateTime.now().millisecondsSinceEpoch % 1000000;
    final desc = 'THUEXE$id';
    final qrUrl =
        'https://img.vietqr.io/image/970422-0909123456-compact2.png?amount=$cleanAmount&addInfo=$desc&accountName=CONG%20TY%20E-MOTION';

    final payos = PayOSPaymentInfoEntity(
      orderCode: '$id',
      amount: cleanAmount.toDouble(),
      description: desc,
      accountNumber: '0909123456',
      accountName: 'CONG TY E-MOTION',
      bankName: 'MBBank (Quân Đội)',
      bin: '970422',
      qrCodeUrl: qrUrl,
      checkoutUrl: state.paymentUrl,
    );

    state = state.copyWith(
      isGeneratingPayOS: false,
      payosPaymentInfo: () => payos,
    );
  }

  /// Bước 3: Nhân viên xác nhận đã thu tiền mặt tại quầy (hoặc bypass test)
  Future<bool> confirmCashPayment() async {
    final rental = state.rental;
    if (rental == null) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: () => null);

    final result = await _updateStatusUseCase(
      rentalId: rental.id,
      status: 'CONFIRM',
    );

    return result.when(
      ok: (_) {
        state = state.copyWith(
          isSubmitting: false,
          isPaymentConfirmed: true,
          currentStep: StaffHandoverStep.inspection,
        );
        return true;
      },
      err: (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
    );
  }

  /// Chụp ảnh hoặc chọn ảnh tự do (Camera hoặc Gallery)
  Future<void> pickPhotos(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final picked = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          maxWidth: 1600,
          maxHeight: 1200,
        );
        if (picked != null) {
          await _uploadSinglePhoto(picked.path);
        }
      } else {
        final pickedList = await _imagePicker.pickMultiImage(
          imageQuality: 85,
          maxWidth: 1600,
          maxHeight: 1200,
        );
        if (pickedList.isNotEmpty) {
          for (final picked in pickedList) {
            await _uploadSinglePhoto(picked.path);
          }
        }
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: () => 'Không thể mở máy ảnh hoặc thư viện: $e',
      );
    }
  }

  Future<void> _uploadSinglePhoto(String path) async {
    final photoId = DateTime.now().microsecondsSinceEpoch.toString();
    final newPhoto = CheckInPhoto(
      id: photoId,
      localPath: path,
      isUploading: true,
    );

    state = state.copyWith(
      photos: [...state.photos, newPhoto],
      isUploadingPhoto: true,
      errorMessage: () => null,
    );

    final uploadResult = await _uploadImageUseCase(path);
    uploadResult.when(
      ok: (url) {
        final updatedPhotos = state.photos.map((p) {
          if (p.id == photoId) {
            return p.copyWith(uploadedUrl: url, isUploading: false);
          }
          return p;
        }).toList();

        state = state.copyWith(
          photos: updatedPhotos,
          isUploadingPhoto: updatedPhotos.any((p) => p.isUploading),
        );
      },
      err: (failure) {
        final updatedPhotos = state.photos
            .where((p) => p.id != photoId)
            .toList();
        state = state.copyWith(
          photos: updatedPhotos,
          isUploadingPhoto: updatedPhotos.any((p) => p.isUploading),
          errorMessage: () => 'Tải ảnh thất bại: ${failure.message}',
        );
      },
    );
  }

  void removePhoto(String photoId) {
    final updated = state.photos.where((p) => p.id != photoId).toList();
    state = state.copyWith(photos: updated);
  }

  void setBattery(int battery) {
    state = state.copyWith(batteryPercentage: battery.clamp(1, 100));
  }

  void setOdometer(int? odo) {
    state = state.copyWith(odometer: () => odo);
  }

  void setNote(String note) {
    state = state.copyWith(note: note);
  }

  /// Bước 4: Lập biên bản nhận xe (Check-in) -> Kích hoạt xe sang ONGOING
  Future<bool> submitCheckinChecklist(String staffEmail) async {
    final rental = state.rental;
    if (rental == null) return false;

    if (!state.isInspectionValid) {
      state = state.copyWith(
        errorMessage: () => 'Vui lòng nhập pin và chụp ít nhất 1 ảnh xe.',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: () => null);

    final uploadedUrls = state.photos
        .where((p) => p.isUploaded)
        .map((p) => p.uploadedUrl)
        .toList();

    final joinedImg = uploadedUrls.join('|');

    final result = await _submitChecklistUseCase(
      rentalId: rental.id,
      staffEmail: staffEmail,
      currentBattery: state.batteryPercentage,
      img: joinedImg,
    );

    return result.when(
      ok: (_) {
        state = state.copyWith(
          isSubmitting: false,
          currentStep: StaffHandoverStep.completed,
        );
        return true;
      },
      err: (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: () => null);
  }
}
