import 'package:flutter/material.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';

/// Modal Bộ lọc tìm kiếm xe (Slide 09 - Bộ lọc tìm kiếm xe)
class VehicleFilterBottomSheet extends StatefulWidget {
  const VehicleFilterBottomSheet({
    this.initialFilter = const VehicleFilter(),
    this.initialCity,
    this.initialSeats,
    this.initialBrand,
    this.initialCarType,
    this.initialPriceRange,
    this.initialSort,
    this.initialRentalType,
    this.initialFuelType,
    this.onApplyFilter,
    super.key,
  });

  final VehicleFilter initialFilter;
  final String? initialCity;
  final String? initialSeats;
  final String? initialBrand;
  final String? initialCarType;
  final String? initialPriceRange;
  final String? initialSort;
  final String? initialRentalType;
  final String? initialFuelType;
  final ValueChanged<VehicleFilter>? onApplyFilter;

  static Future<VehicleFilter?> show(
    BuildContext context, {
    VehicleFilter initialFilter = const VehicleFilter(),
  }) {
    return showModalBottomSheet<VehicleFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VehicleFilterBottomSheet(
        initialFilter: initialFilter,
        initialCity: initialFilter.city,
        initialSeats: initialFilter.seats,
        initialBrand: initialFilter.brand,
        initialCarType: initialFilter.carType,
        initialPriceRange: initialFilter.priceRange,
        initialSort: initialFilter.sort,
      ),
    );
  }

  @override
  State<VehicleFilterBottomSheet> createState() =>
      _VehicleFilterBottomSheetState();
}

class _VehicleFilterBottomSheetState extends State<VehicleFilterBottomSheet> {
  late String _city;
  late String _seats;
  late String _brand;
  late String _carType;
  late String _priceRange;
  late String _sort;

  @override
  void initState() {
    super.initState();
    final rawCity = widget.initialCity ?? widget.initialFilter.city ?? 'Hà Nội';
    if (rawCity.toUpperCase().contains('HCM') ||
        rawCity.toUpperCase().contains('HỒ CHÍ MINH') ||
        rawCity.toUpperCase().contains('TP_HCM')) {
      _city = 'Hồ Chí Minh';
    } else {
      _city = 'Hà Nội';
    }
    _seats = widget.initialSeats ?? widget.initialFilter.seats;
    _brand = widget.initialBrand ?? widget.initialFilter.brand;
    _carType = widget.initialCarType ?? widget.initialFilter.carType;
    _priceRange = widget.initialPriceRange ?? widget.initialFilter.priceRange;
    _sort = widget.initialSort ?? widget.initialFilter.sort;
  }

  void _reset() {
    setState(() {
      _city = 'Hà Nội';
      _seats = 'Tất cả';
      _brand = 'Tất cả';
      _carType = 'Tất cả';
      _priceRange = 'Tất cả';
      _sort = 'Giá thấp đến cao';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 32),
                const Text(
                  'Bộ lọc',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Filter content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                // 1. Khu vực / Thành phố (Khớp với BE: Hà Nội, Hồ Chí Minh)
                _buildSectionTitle('Khu vực / Thành phố'),
                _buildFilterChips(
                  options: const ['Hà Nội', 'Hồ Chí Minh'],
                  selected: _city,
                  onSelected: (val) => setState(() => _city = val),
                ),
                const SizedBox(height: 18),

                // 2. Số chỗ (Khớp với BE: 4 chỗ, 5 chỗ, 7 chỗ)
                _buildSectionTitle('Số chỗ'),
                _buildFilterChips(
                  options: const ['Tất cả', '4 chỗ', '5 chỗ', '7 chỗ'],
                  selected: _seats,
                  onSelected: (val) => setState(() => _seats = val),
                ),
                const SizedBox(height: 18),

                // 3. Hãng xe (Khớp thực tế các hãng xe có trong DB: VinFast, Tesla, BYD)
                _buildSectionTitle('Hãng xe'),
                _buildFilterChips(
                  options: const [
                    'Tất cả',
                    'VinFast',
                    'Tesla',
                    'BYD',
                  ],
                  selected: _brand,
                  onSelected: (val) => setState(() => _brand = val),
                ),
                const SizedBox(height: 18),

                // 3. Loại xe (Khớp với enum BE: SUV, SEDAN, CROSSOVER, MPV, HATCHBACK)
                _buildSectionTitle('Loại xe'),
                _buildFilterChips(
                  options: const [
                    'Tất cả',
                    'SUV',
                    'Sedan',
                    'Crossover',
                    'MPV',
                    'Hatchback',
                  ],
                  selected: _carType,
                  onSelected: (val) => setState(() => _carType = val),
                ),
                const SizedBox(height: 18),

                // 4. Mức giá thuê (Khớp với minPrice, maxPrice của BE)
                _buildSectionTitle('Mức giá thuê'),
                _buildFilterChips(
                  options: const [
                    'Tất cả',
                    'Dưới 500K',
                    '500K - 1 Triệu',
                    'Trên 1 Triệu',
                  ],
                  selected: _priceRange,
                  onSelected: (val) => setState(() => _priceRange = val),
                ),
                const SizedBox(height: 18),

                // 5. Sắp xếp theo
                _buildSectionTitle('Sắp xếp theo'),
                _buildFilterChips(
                  options: const [
                    'Giá thấp đến cao',
                    'Giá cao đến thấp',
                    'Phổ biến nhất',
                  ],
                  selected: _sort,
                  onSelected: (val) => setState(() => _sort = val),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom Action Buttons
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  // Nút Đặt lại
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      onPressed: _reset,
                      child: const Text(
                        'Đặt lại',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Nút Áp dụng
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final filter = widget.initialFilter.copyWith(
                          city: _city,
                          location: '$_city • Tất cả các trạm',
                          clearStation: true,
                          seats: _seats,
                          brand: _brand,
                          carType: _carType,
                          priceRange: _priceRange,
                          sort: _sort,
                        );
                        widget.onApplyFilter?.call(filter);
                        Navigator.pop(context, filter);
                      },
                      child: const Text(
                        'Áp dụng',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildFilterChips({
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = option == selected;
        return InkWell(
          onTap: () => onSelected(option),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF1976D2)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF1976D2)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF334155),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
