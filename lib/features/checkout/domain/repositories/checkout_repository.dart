import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
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

  /// Cập nhật biên bản kiểm tra xe đã tồn tại (CHECK_OUT)
  Future<Result<RentalChecklistEntity>> updateChecklist({
    required int id,
    required int rentalId,
    required String type,
    required double currentBattery,
    required String img,
    required String staffEmail,
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

  /// Tạo liên kết thanh toán PayOS đền bù đơn thuê (khi số tiền vượt cọc)
  Future<Result<PayOSPaymentInfoEntity>> createRentalCompensationPaymentLink(
    int rentalId, {
    double? amount,
  });

  /// Kiểm tra và xác nhận trạng thái thanh toán đền bù đơn thuê với PayOS
  Future<Result<bool>> checkRentalCompensationPayment(int rentalId);
}
