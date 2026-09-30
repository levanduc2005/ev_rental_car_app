import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    String? errorMessage,
    @Default([]) List<VehicleEntity> vehicles,
    @Default([]) List<String> brands,
    String? selectedBrand,
  }) = _HomeState;

  const HomeState._();

  /// Danh sách xe sang / xế xịn
  List<VehicleEntity> get luxuryVehicles {
    var list = vehicles.where((v) => v.isLuxury).toList();
    if (selectedBrand != null) {
      list = list
          .where((v) => v.brand.toUpperCase() == selectedBrand!.toUpperCase())
          .toList();
    }
    return list;
  }

  /// Danh sách xe phổ thông / xe điện gợi ý
  List<VehicleEntity> get recommendedVehicles {
    var list = vehicles.where((v) => !v.isLuxury).toList();
    if (list.isEmpty) list = vehicles;
    if (selectedBrand != null) {
      list = list
          .where((v) => v.brand.toUpperCase() == selectedBrand!.toUpperCase())
          .toList();
    }
    return list;
  }

  /// Kiểm tra có dữ liệu để hiển thị hay không
  bool get hasData => vehicles.isNotEmpty;
}
