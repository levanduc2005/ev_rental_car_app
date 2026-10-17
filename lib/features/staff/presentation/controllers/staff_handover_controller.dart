import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';
import 'package:rental_car/features/checkin/domain/usecases/upload_car_image_usecase.dart';
import 'package:rental_car/features/checkin/presentation/controllers/checkin_state.dart';
import 'package:rental_car/features/checkin/presentation/providers/checkin_providers.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/domain/usecases/convert_reservation_to_rental_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/generate_staff_contract_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/get_checkin_payment_url_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/submit_staff_checklist_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/update_rental_status_usecase.dart';
import 'package:rental_car/features/staff/presentation/controllers/staff_handover_state.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';

class StaffHandoverController extends Notifier<StaffHandoverState> {
  ConvertReservationToRentalUseCase? _injectedConvertUseCase;
  GenerateStaffContractUseCase? _injectedContractUseCase;
  GetCheckInPaymentUrlUseCase? _injectedPaymentUseCase;
  UpdateRentalStatusUseCase? _injectedUpdateStatusUseCase;
  SubmitStaffCheckListUseCase? _injectedSubmitChecklistUseCase;
  UploadCarImageUseCase? _injectedUploadImageUseCase;
  ImagePicker? _injectedImagePicker;

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
    ImagePicker? imagePicker,
  }) {
    _injectedConvertUseCase = convertUseCase;
    _injectedContractUseCase = contractUseCase;
    _injectedPaymentUseCase = paymentUseCase;
    _injectedUpdateStatusUseCase = updateStatusUseCase;
    _injectedSubmitChecklistUseCase = submitChecklistUseCase;
    _injectedUploadImageUseCase = uploadImageUseCase;
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
      if (status == 'CONFIRM') {
        step = StaffHandoverStep.inspection;
      } else if (status == 'ONGOING') {
        step = StaffHandoverStep.completed;
      }

      state = state.copyWith(
        rental: rental,
        currentStep: step,
        batteryPercentage: rental.currentBattery?.toInt() ?? 95,
      );
    }
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
