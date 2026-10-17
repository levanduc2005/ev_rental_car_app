import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/emergency/domain/entities/emergency_type.dart';
import 'package:rental_car/features/emergency/domain/entities/sos_report_entity.dart';
import 'package:rental_car/features/emergency/domain/usecases/submit_emergency_report_usecase.dart';
import 'package:rental_car/features/emergency/domain/usecases/upload_incident_image_usecase.dart';
import 'package:rental_car/features/emergency/presentation/controllers/emergency_state.dart';
import 'package:rental_car/features/emergency/presentation/providers/emergency_providers.dart';

class EmergencyController extends Notifier<EmergencyState> {
  SubmitEmergencyReportUseCase get _submitReportUseCase =>
      ref.read(submitEmergencyReportUseCaseProvider);
  UploadIncidentImageUseCase get _uploadImageUseCase =>
      ref.read(uploadIncidentImageUseCaseProvider);

  final ImagePicker _picker = ImagePicker();

  @override
  EmergencyState build() {
    // Tự động yêu cầu định vị GPS ngầm khi mở màn hình
    Future.microtask(() => fetchCurrentLocation());
    return const EmergencyState();
  }

  void selectType(EmergencyType type) {
    state = state.copyWith(selectedType: type);
  }

  Future<void> fetchCurrentLocation() async {
    state = state.copyWith(isLoadingLocation: true, clearLocationError: true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLoadingLocation: false,
          locationError: 'Dịch vụ định vị GPS chưa được bật trên thiết bị.',
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            isLoadingLocation: false,
            locationError: 'Quyền truy cập vị trí bị từ chối.',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLoadingLocation: false,
          locationError: 'Quyền vị trí bị từ chối vĩnh viễn trong Cài đặt.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      state = state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
        isLoadingLocation: false,
        clearLocationError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingLocation: false,
        locationError: 'Không thể lấy tọa độ GPS: $e',
      );
    }
  }

  Future<void> pickAndUploadImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      state = state.copyWith(
        selectedImagePath: pickedFile.path,
        isUploadingImage: true,
        clearErrorMessage: true,
      );

      final result = await _uploadImageUseCase(pickedFile.path);
      result.when(
        ok: (url) {
          state = state.copyWith(
            uploadedImageUrl: url,
            isUploadingImage: false,
          );
        },
        err: (failure) {
          state = state.copyWith(
            isUploadingImage: false,
            errorMessage: 'Lỗi tải ảnh: ${failure.message}',
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isUploadingImage: false,
        errorMessage: 'Lỗi chọn ảnh: $e',
      );
    }
  }

  void removeImage() {
    state = state.copyWith(clearImage: true);
  }

  Future<Result<SosReportEntity>> submitEmergencyReport({
    required String description,
    int? rentalId,
    String? userEmail,
  }) async {
    state = state.copyWith(isSubmitting: true, clearErrorMessage: true);

    final result = await _submitReportUseCase(
      type: state.selectedType,
      description: description,
      imageUrl: state.uploadedImageUrl,
      latitude: state.latitude,
      longitude: state.longitude,
      rentalId: rentalId,
      userEmail: userEmail,
    );

    result.when(
      ok: (report) {
        state = state.copyWith(isSubmitting: false, submittedReport: report);
      },
      err: (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
      },
    );

    return result;
  }
}
