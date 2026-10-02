import 'package:intl/intl.dart';

class CreateReservationRequestModel {
  const CreateReservationRequestModel({
    required this.userEmail,
    required this.vehicleId,
    required this.stationId,
    required this.startTime,
    required this.endTime,
    this.paymentMethod = 'PAYOS',
  });

  final String userEmail;
  final int vehicleId;
  final int stationId;
  final DateTime startTime;
  final DateTime endTime;
  final String paymentMethod;

  Map<String, dynamic> toJson() {
    // Format dạng ISO LocalDateTime tương thích Spring Boot (ví dụ: 2026-09-27T14:00:00)
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

    return {
      'userEmail': userEmail,
      'vehicleId': vehicleId,
      'stationId': stationId,
      'startTime': formatter.format(startTime),
      'endTime': formatter.format(endTime),
      'paymentMethod': paymentMethod,
    };
  }
}
