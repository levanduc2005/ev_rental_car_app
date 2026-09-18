import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';

/// Bộ kiểu chữ chuẩn (Typography Design Tokens) cho toàn bộ ứng dụng.
///
/// Thay vì viết nhiều dòng `TextStyle(...)` với `fontSize`, `fontWeight`, `color`
/// rườm rà trong các file widget, hãy sử dụng trực tiếp các kiểu chữ tại đây.
abstract final class AppTextStyles {
  // --- Tiêu đề (Headings) ---
  /// Tiêu đề lớn nhất (24px, Đậm) - Màn hình chính, tiêu đề chào mừng
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  /// Tiêu đề vừa (20px, Đậm) - Tiêu đề trang, tiêu đề modal/form
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  /// Tiêu đề nhỏ (18px, Đậm vừa) - Tiêu đề thẻ (Card), nhóm chức năng
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // --- Tiêu đề mục (Title) ---
  /// Tiêu đề section (16px, Đậm vừa)
  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Tiêu đề vừa (15px, Đậm vừa) - Nhãn nút Google, tiêu đề phụ
  static const TextStyle titleMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // --- Nội dung & Phụ đề (Body & Subtitle) ---
  /// Nội dung văn bản thông thường (14px, Regular)
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Nội dung văn bản đậm vừa (14px, Medium)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Phụ đề / Mô tả (14px, Regular, Màu xám)
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Phụ đề nhỏ (13px, Regular, Màu xám)
  static const TextStyle subtitleSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // --- Nút bấm & Ô nhập (Buttons & Inputs) ---
  /// Nhãn nút bấm chính (15px, Đậm vừa, Màu trắng)
  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  /// Nhãn nút viền / phụ (15px, Đậm vừa, Màu chữ chính)
  static const TextStyle buttonOutlined = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Nhãn ô nhập liệu (13px, Đậm vừa, Màu xám)
  static const TextStyle inputLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// Chữ người dùng nhập trong ô (15px, Regular)
  static const TextStyle inputText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  /// Gợi ý trong ô nhập (14px, Regular, Màu xám nhạt)
  static const TextStyle hint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // --- Chú thích & Lỗi (Caption & Error) ---
  /// Chú thích nhỏ (12px, Regular, Màu xám)
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Thông báo lỗi validation (12px, Regular, Màu đỏ)
  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
  );
}
