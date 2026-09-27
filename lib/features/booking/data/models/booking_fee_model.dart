import 'package:rental_car/features/booking/domain/entities/booking_fee_entity.dart';

class FeeItemModel {
  const FeeItemModel({
    required this.description,
    required this.feeType,
    required this.value,
  });

  final String description;
  final String feeType;
  final double value;

  factory FeeItemModel.fromJson(Map<String, dynamic> json) {
    return FeeItemModel(
      description: json['description'] as String? ?? '',
      feeType: json['feeType'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  FeeItemEntity toEntity() => FeeItemEntity(
        description: description,
        feeType: feeType,
        value: value,
      );
}

class BookingFeeModel {
  const BookingFeeModel({
    required this.bookingFee,
    required this.depositFee,
    required this.holdCarFee,
    required this.totalAmount,
    this.items = const [],
  });

  final double bookingFee;
  final double depositFee;
  final double holdCarFee;
  final double totalAmount;
  final List<FeeItemModel> items;

  factory BookingFeeModel.fromList(List<dynamic> list) {
    double booking = 0.0;
    double deposit = 0.0;
    double holdCar = 500000.0;
    double total = 0.0;
    final List<FeeItemModel> parsedItems = [];

    for (final raw in list) {
      if (raw is Map<String, dynamic>) {
        final item = FeeItemModel.fromJson(raw);
        parsedItems.add(item);
        final type = item.feeType.toUpperCase();
        if (type == 'BOOKING_FEE') {
          booking = item.value;
        } else if (type == 'DEPOSIT') {
          deposit = item.value;
        } else if (type == 'HOLD_CAR') {
          holdCar = item.value > 0 ? item.value : 500000.0;
        } else if (type == 'TOTAL_AMOUNT') {
          total = item.value;
        }
      }
    }

    if (total <= 0) {
      total = booking + deposit;
    }

    return BookingFeeModel(
      bookingFee: booking,
      depositFee: deposit,
      holdCarFee: holdCar,
      totalAmount: total,
      items: parsedItems,
    );
  }

  BookingFeeEntity toEntity() {
    return BookingFeeEntity(
      bookingFee: bookingFee,
      depositFee: depositFee,
      holdCarFee: holdCarFee,
      totalAmount: totalAmount,
      items: items.map((e) => e.toEntity()).toList(),
    );
  }
}
