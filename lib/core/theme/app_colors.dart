import 'package:flutter/material.dart';

/// Bảng màu chuẩn (Design Tokens) cho toàn bộ ứng dụng thuê xe điện.
///
/// Tránh hardcode mã màu hex ở các file widget; hãy dùng các biến tại đây
/// để đảm bảo giao diện đồng nhất và dễ dàng thay đổi thương hiệu.
abstract final class AppColors {
  // --- Màu thương hiệu (Brand Colors) ---
  /// Màu xanh điện chính (Primary Electric Blue)
  static const Color primary = Color(0xFF3D5AFE);

  /// Màu xanh lá sinh thái / trạm sạc / pin đầy (Eco Electric Green)
  static const Color accent = Color(0xFF10B981);

  // --- Màu văn bản (Typography Colors) ---
  /// Màu chữ chính (Đen than Slate-900) - Dùng cho tiêu đề, văn bản quan trọng
  static const Color textPrimary = Color(0xFF0F172A);

  /// Màu chữ phụ (Xám Slate-500) - Dùng cho phụ đề, nhãn, mô tả
  static const Color textSecondary = Color(0xFF64748B);

  /// Màu chữ làm mờ (Xám nhạt Slate-400) - Dùng cho hint text, ghi chú nhỏ
  static const Color textMuted = Color(0xFF94A3B8);

  // --- Màu nền & Bề mặt (Background & Surface) ---
  /// Nền chính của toàn app (Trắng xám dịu mắt Slate-50)
  static const Color background = Color(0xFFF8FAFC);

  /// Bề mặt thẻ, ô nhập, hộp thoại (Trắng tinh khiết)
  static const Color surface = Colors.white;

  /// Màu viền chuẩn (Xám nhạt Slate-200) cho input, card, divider
  static const Color border = Color(0xFFE2E8F0);

  /// Màu viền khi được chọn (Active / Focused border)
  static const Color borderFocused = Color(0xFF3D5AFE);

  // --- Màu trạng thái (Feedback Colors) ---
  /// Trạng thái thành công (Xanh lục)
  static const Color success = Color(0xFF10B981);

  /// Trạng thái cảnh báo (Cam vàng)
  static const Color warning = Color(0xFFF59E0B);

  /// Trạng thái lỗi (Đỏ)
  static const Color error = Color(0xFFEF4444);

  /// Trạng thái thông tin (Xanh dương)
  static const Color info = Color(0xFF3B82F6);
}
