import 'package:intl/intl.dart';

class CreateReservationRequestModel {
  const CreateReservationRequestModel({
    required this.userEmail,
    required this.vehicleId,
    required this.stationId,
    required this.startTime,
    required this.endTime,
    this.paymentMethod = 'PAYOS',
    this.isInstant,
  });

  final String userEmail;
  final int vehicleId;
  final int stationId;
  final DateTime startTime;
  final DateTime endTime;
  final String paymentMethod;
  final bool? isInstant;

  Map<String, dynamic> toJson() {
    // Format dạng ISO LocalDateTime tương thích Spring Boot (ví dụ: 2026-09-27T14:00:00)
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

    final data = <String, dynamic>{
      'userEmail': userEmail,
      'vehicleId': vehicleId,
      'stationId': stationId,
      'startTime': formatter.format(startTime),
      'endTime': formatter.format(endTime),
      'paymentMethod': paymentMethod,
    };
    if (isInstant != null) {
      data['isInstant'] = isInstant;
    }
    return data;
  }
}
