import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/booking/presentation/models/bank_app_item.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';

/// Provider lấy danh sách toàn bộ ứng dụng ngân hàng động từ VietQR Open API
final supportedBanksProvider = FutureProvider<List<BankAppItem>>((ref) async {
  final useCase = ref.watch(getSupportedBanksUseCaseProvider);
  final result = await useCase();
  return result.when(
    ok: (banks) => banks,
    err: (_) => const <BankAppItem>[],
  );
});
