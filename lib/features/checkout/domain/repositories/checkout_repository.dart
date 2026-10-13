import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_overview_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_log_entity.dart';

abstract class CheckoutRepository {
  /// Lấy danh sách biên bản kiểm tra (CHECK_IN / CHECK_OUT) theo rentalId
  Future<Result<List<RentalChecklistEntity>>> getChecklistsByRentalId(
    int rentalId,
  );

  /// Tạo biên bản kiểm tra xe mới (CHECK_OUT)
  Future<Result<RentalChecklistEntity>> createChecklist({
    required int rentalId,
    required String type, // 'CHECK_OUT'
    required double currentBattery,
    required String img,
    String? staffEmail,
  });

  /// Lấy biên bản nhật ký xe (VehicleLog) nếu có
  Future<Result<VehicleLogEntity?>> getVehicleLogByRentalId(int rentalId);

  /// Tạo hoặc cập nhật biên bản sự cố / hư hại xe (VehicleLog)
  Future<Result<VehicleLogEntity>> createOrUpdateVehicleLog({
    required int rentalId,
    required int vehicleId,
    required List<Map<String, dynamic>> repairItems,
    required List<String> imgs,
    int? staffId,
    int? logId,
  });

  /// Lấy bảng kê chi tiết tài chính quyết toán
  Future<Result<RentalOverviewEntity>> getRentalOverview(int rentalId);

  /// Thực hiện quyết toán cọc & hoàn tất hợp đồng thuê
  Future<Result<Map<String, dynamic>>> processCheckoutPayment(int rentalId);
}
