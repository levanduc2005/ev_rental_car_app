import 'package:rental_car/features/checkout/data/models/rental_checklist_model.dart';
import 'package:rental_car/features/checkout/data/models/rental_overview_model.dart';
import 'package:rental_car/features/checkout/data/models/vehicle_log_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<List<RentalChecklistModel>> getChecklistsByRentalId(int rentalId);

  Future<RentalChecklistModel> createChecklist({
    required int rentalId,
    required String type,
    required double currentBattery,
    required String img,
    String? staffEmail,
  });

  Future<VehicleLogModel?> getVehicleLogByRentalId(int rentalId);

  Future<VehicleLogModel> createOrUpdateVehicleLog({
    required int rentalId,
    required int vehicleId,
    required List<Map<String, dynamic>> repairItems,
    required List<String> imgs,
    int? staffId,
    int? logId,
  });

  Future<RentalOverviewModel> getRentalOverview(int rentalId);

  Future<Map<String, dynamic>> processCheckoutPayment(int rentalId);
}
