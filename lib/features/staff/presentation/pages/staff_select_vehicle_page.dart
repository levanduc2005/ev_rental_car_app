import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/staff/domain/entities/renter_entity.dart';
import 'package:rental_car/features/staff/presentation/pages/staff_create_rental_page.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';
import 'package:rental_car/features/staff/presentation/widgets/staff_vehicle_card.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

class StaffSelectVehiclePage extends ConsumerStatefulWidget {
  const StaffSelectVehiclePage({required this.renter, super.key});

  final RenterEntity renter;

  @override
  ConsumerState<StaffSelectVehiclePage> createState() =>
      _StaffSelectVehiclePageState();
}

class _StaffSelectVehiclePageState
    extends ConsumerState<StaffSelectVehiclePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(staffDashboardControllerProvider.notifier)
          .fetchStationVehicles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSelectVehicle(VehicleEntity vehicle) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            StaffCreateRentalPage(vehicle: vehicle, renter: widget.renter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(staffDashboardControllerProvider);
    final stationName =
        dashboardState.currentStation?.name ?? 'Trạm xe đang trực';

    final availableVehicles = dashboardState.vehicles.where((v) {
      final s = v.status.trim().toUpperCase();
      final isAvailable =
          s == 'AVAILABLE' || s == 'SẴN SÀNG' || s == 'SAN SANG';
      if (!isAvailable) return false;
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final nameMatches = v.name.toLowerCase().contains(q);
      final plateMatches = v.plateNumber?.toLowerCase().contains(q) ?? false;
      final brandMatches = v.brand.toLowerCase().contains(q);
      return nameMatches || plateMatches || brandMatches;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Chọn xe tại trạm',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(staffDashboardControllerProvider.notifier)
            .fetchStationVehicles(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRenterCard(widget.renter),
              const SizedBox(height: 12),
              _buildStationAndSearchHeader(
                stationName,
                availableVehicles.length,
              ),
              const SizedBox(height: 12),
              if (dashboardState.isLoadingVehicles)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (availableVehicles.isEmpty)
                _buildEmptyState()
              else
                ...availableVehicles.map(
                  (vehicle) => StaffVehicleCard(
                    vehicle: vehicle,
                    onTap: () => _onSelectVehicle(vehicle),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRenterCard(RenterEntity renter) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        renter.fullName.isNotEmpty
                            ? renter.fullName
                            : renter.email,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${renter.point} e-Point',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D4ED8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  renter.email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                if (renter.phone != null && renter.phone!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'SĐT: ${renter.phone!}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationAndSearchHeader(String stationName, int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: Color(0xFF059669),
                ),
                const SizedBox(width: 4),
                Text(
                  stationName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
            Text(
              '$count xe sẵn sàng',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF059669),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _searchController,
          onChanged: (val) {
            setState(() {
              _searchQuery = val.trim();
            });
          },
          decoration: InputDecoration(
            hintText: 'Tìm theo tên xe, biển số...',
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            prefixIcon: const Icon(
              Icons.search,
              size: 20,
              color: Color(0xFF64748B),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.directions_car_filled_outlined,
            size: 56,
            color: Color(0xFFCBD5E1),
          ),
          const SizedBox(height: 12),
          const Text(
            'Không có xe nào sẵn sàng',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _searchQuery.isNotEmpty
                ? 'Không tìm thấy xe nào khớp với từ khóa "$_searchQuery"'
                : 'Hiện tại toàn bộ xe tại trạm này đều đang được thuê hoặc bảo dưỡng.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
