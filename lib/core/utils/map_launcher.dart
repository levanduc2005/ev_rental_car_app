import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tiện ích mở ứng dụng Bản đồ (Google Maps) để dẫn đường tới trạm xe hoặc địa điểm
abstract final class MapLauncher {
  /// Mở Google Maps để chỉ đường tới trạm xe (ưu tiên tọa độ GPS, fallback tên & địa chỉ)
  static Future<void> openDirections({
    required BuildContext context,
    double? latitude,
    double? longitude,
    String? stationName,
    required String stationAddress,
  }) async {
    final Uri googleMapsUrl;
    if (latitude != null &&
        longitude != null &&
        latitude != 0.0 &&
        longitude != 0.0) {
      // Ưu tiên 1: Dẫn đường bằng tọa độ GPS chuẩn xác
      googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
      );
    } else {
      // Ưu tiên 2: Fallback dẫn đường theo tên và địa chỉ trạm
      final query = Uri.encodeComponent(
        stationName != null && stationName.isNotEmpty
            ? '$stationName, $stationAddress'
            : stationAddress,
      );
      googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$query',
      );
    }

    try {
      final launched = await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể mở ứng dụng Bản đồ.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi mở bản đồ: $e')));
      }
    }
  }
}
