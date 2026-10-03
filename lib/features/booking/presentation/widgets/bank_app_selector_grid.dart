import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/presentation/models/bank_app_item.dart';
import 'package:rental_car/features/booking/presentation/providers/supported_banks_provider.dart';
import 'package:rental_car/features/booking/presentation/widgets/bank_app_list_bottom_sheet.dart';

/// Component hiển thị danh sách Top 8 ngân hàng phổ biến (Phương án 1A)
/// lấy dữ liệu hoàn toàn động từ VietQR Open API, hỗ trợ Shimmer loading và chọn thêm
class BankAppSelectorGrid extends ConsumerWidget {
  const BankAppSelectorGrid({
    required this.onBankSelected,
    this.selectedBank,
    super.key,
  });

  final BankAppItem? selectedBank;
  final ValueChanged<BankAppItem> onBankSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banksAsync = ref.watch(supportedBanksProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.account_balance,
                    color: Color(0xFF2563EB),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Chọn ứng dụng ngân hàng',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  final allBanks = banksAsync.value ?? [];
                  final picked = await BankAppListBottomSheet.show(
                    context,
                    selectedBank: selectedBank,
                    allBanks: allBanks.isNotEmpty ? allBanks : null,
                  );
                  if (picked != null) {
                    onBankSelected(picked);
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'Xem thêm',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Color(0xFF2563EB),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Chọn ngân hàng bạn đang dùng để thanh toán 1-chạm không cần quét mã',
            style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),

          // Body theo trạng thái AsyncValue của supportedBanksProvider
          banksAsync.when(
            loading: () => const _SkeletonBankGrid(),
            error: (err, stack) => _ErrorBankGrid(
              onRetry: () => ref.refresh(supportedBanksProvider),
            ),
            data: (allBanks) {
              if (allBanks.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Không tìm thấy danh sách ngân hàng',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                );
              }

              final popularBanks = allBanks.take(8).toList();
              final effectiveSelected =
                  selectedBank ??
                  (popularBanks.isNotEmpty ? popularBanks.first : null);
              final isSelectedInPopular =
                  effectiveSelected == null ||
                  popularBanks.any((b) => b.appId == effectiveSelected.appId);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị ngân hàng tùy chọn nếu người dùng chọn ngoài top 8
                  if (!isSelectedInPopular) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2563EB),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Image.network(
                              effectiveSelected.logoUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.account_balance,
                                    size: 16,
                                    color: Color(0xFF2563EB),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  effectiveSelected.shortName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                                Text(
                                  effectiveSelected.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF2563EB),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Grid Top 8 phổ biến (4 cột x 2 hàng)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: popularBanks.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.88,
                        ),
                    itemBuilder: (context, index) {
                      final bank = popularBanks[index];
                      final isSelected =
                          effectiveSelected != null &&
                          bank.appId == effectiveSelected.appId;

                      return InkWell(
                        onTap: () => onBankSelected(bank),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEFF6FF)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFFE2E8F0),
                              width: isSelected ? 2.0 : 1.0,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF2563EB,
                                      ).withValues(alpha: 0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF93C5FD)
                                        : const Color(0xFFF1F5F9),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    bank.logoUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.account_balance,
                                              size: 18,
                                              color: Color(0xFF2563EB),
                                            ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                bank.shortName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? const Color(0xFF1D4ED8)
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Shimmer Skeleton loading 8 ô ngân hàng dạng pulsing mượt mà
class _SkeletonBankGrid extends StatefulWidget {
  const _SkeletonBankGrid();

  @override
  State<_SkeletonBankGrid> createState() => _SkeletonBankGridState();
}

class _SkeletonBankGridState extends State<_SkeletonBankGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.35,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final opacity = _animation.value;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9).withValues(alpha: opacity),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: opacity),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 44,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: opacity),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// Trạng thái báo lỗi và nút thử lại khi không gọi được API VietQR
class _ErrorBankGrid extends StatelessWidget {
  const _ErrorBankGrid({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.cloud_off_outlined, color: Colors.grey, size: 32),
          const SizedBox(height: 8),
          const Text(
            'Không thể tải danh sách ứng dụng ngân hàng',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 14),
            label: const Text('Thử lại', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              foregroundColor: const Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }
}
