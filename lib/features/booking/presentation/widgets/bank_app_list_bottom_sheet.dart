import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/domain/entities/bank_app_item.dart';
import 'package:rental_car/features/booking/presentation/providers/supported_banks_provider.dart';

/// Modal BottomSheet cho phép tìm kiếm và chọn trong toàn bộ danh sách ngân hàng tại Việt Nam (VietQR)
/// Dữ liệu nạp động 100%, hỗ trợ Shimmer loading và tìm kiếm tức thì
class BankAppListBottomSheet extends ConsumerStatefulWidget {
  const BankAppListBottomSheet({
    required this.onBankSelected,
    this.selectedBank,
    this.allBanks,
    super.key,
  });

  final BankAppItem? selectedBank;
  final ValueChanged<BankAppItem> onBankSelected;
  final List<BankAppItem>? allBanks;

  static Future<BankAppItem?> show(
    BuildContext context, {
    BankAppItem? selectedBank,
    List<BankAppItem>? allBanks,
  }) {
    return showModalBottomSheet<BankAppItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BankAppListBottomSheet(
        selectedBank: selectedBank,
        allBanks: allBanks,
        onBankSelected: (bank) => Navigator.of(ctx).pop(bank),
      ),
    );
  }

  @override
  ConsumerState<BankAppListBottomSheet> createState() =>
      _BankAppListBottomSheetState();
}

class _BankAppListBottomSheetState
    extends ConsumerState<BankAppListBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<BankAppItem> _sourceBanks = [];
  List<BankAppItem> _filteredBanks = [];

  @override
  void initState() {
    super.initState();
    if (widget.allBanks != null && widget.allBanks!.isNotEmpty) {
      _sourceBanks = widget.allBanks!;
      _filteredBanks = _sourceBanks;
    }
    _searchController.addListener(_filterBanks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBanks() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() => _filteredBanks = _sourceBanks);
    } else {
      setState(() {
        _filteredBanks = _sourceBanks.where((bank) {
          return bank.name.toLowerCase().contains(query) ||
              bank.shortName.toLowerCase().contains(query) ||
              bank.code.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Nếu widget.allBanks chưa được truyền vào, nạp trực tiếp qua Riverpod Provider
    final banksAsync = ref.watch(supportedBanksProvider);
    final isExternalLoading = widget.allBanks == null && banksAsync.isLoading;

    if (_sourceBanks.isEmpty && banksAsync.hasValue) {
      _sourceBanks = banksAsync.value!;
      if (_searchController.text.isEmpty) {
        _filteredBanks = _sourceBanks;
      }
    }

    return Container(
      constraints: BoxConstraints(maxHeight: size.height * 0.8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chọn ứng dụng ngân hàng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên ngân hàng, mã...',
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.grey,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Body: Loading Shimmer hoặc Danh sách ngân hàng
          Expanded(
            child: isExternalLoading
                ? const _SkeletonBankList()
                : _filteredBanks.isEmpty
                ? const Center(
                    child: Text(
                      'Không tìm thấy ngân hàng phù hợp',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredBanks.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 68,
                      color: Color(0xFFF1F5F9),
                    ),
                    itemBuilder: (context, index) {
                      final bank = _filteredBanks[index];
                      final isSelected =
                          widget.selectedBank != null &&
                          bank.appId == widget.selectedBank!.appId;

                      return ListTile(
                        leading: Container(
                          width: 44,
                          height: 44,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFFE2E8F0),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              bank.logoUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.account_balance,
                                    color: Color(0xFF2563EB),
                                    size: 22,
                                  ),
                            ),
                          ),
                        ),
                        title: Text(
                          bank.shortName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isSelected
                                ? const Color(0xFF2563EB)
                                : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          bank.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: Color(0xFF2563EB),
                                size: 22,
                              )
                            : null,
                        onTap: () => widget.onBankSelected(bank),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer Skeleton loading cho danh sách ngân hàng trong BottomSheet
class _SkeletonBankList extends StatefulWidget {
  const _SkeletonBankList();

  @override
  State<_SkeletonBankList> createState() => _SkeletonBankListState();
}

class _SkeletonBankListState extends State<_SkeletonBankList>
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
        return ListView.builder(
          itemCount: 6,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9).withValues(alpha: opacity),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF1F5F9,
                            ).withValues(alpha: opacity),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF1F5F9,
                            ).withValues(alpha: opacity),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
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
