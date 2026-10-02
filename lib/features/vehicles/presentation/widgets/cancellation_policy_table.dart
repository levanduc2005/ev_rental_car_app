import 'package:flutter/material.dart';

class _PolicyItem {
  const _PolicyItem({
    required this.title,
    required this.color,
    required this.regularDays,
    required this.holidayDays,
  });

  final String title;
  final Color color;
  final String regularDays;
  final String holidayDays;
}

/// Bảng chính sách huỷ chuyến (Chuẩn e-Motion CarCancellationPolicy.jsx)
class CancellationPolicyTable extends StatelessWidget {
  const CancellationPolicyTable({super.key});

  static const List<_PolicyItem> _items = [
    _PolicyItem(
      title: 'Hoàn 100% tiền giữ chỗ',
      color: Color(0xFF10B981),
      regularDays: 'Trước chuyến đi > 5 ngày',
      holidayDays: 'Trước chuyến đi > 5 ngày',
    ),
    _PolicyItem(
      title: 'Không hoàn tiền giữ chỗ',
      color: Color(0xFFEF4444),
      regularDays: 'Trong vòng 5 ngày trước chuyến đi',
      holidayDays: 'Trong vòng 5 ngày trước chuyến đi',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Chính sách huỷ chuyến',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'e-Motion',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0284C7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.4),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                },
                children: [
                  _buildHeaderRow(),
                  ..._items.map(_buildDataRow),
                ],
              ),
              _buildFooterNotice(),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildHeaderRow() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xFFF1F5F9)),
      children: [
        _HeaderCell('Quy định', horizontalPadding: 10),
        _HeaderCell('Ngày thường'),
        _HeaderCell('Ngày lễ, Tết'),
      ],
    );
  }

  TableRow _buildDataRow(_PolicyItem item) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        ),
        _DataCell(item.regularDays),
        _DataCell(item.holidayDays),
      ],
    );
  }

  Widget _buildFooterNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 14, color: Color(0xFF64748B)),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'Hoàn tiền giữ chỗ nếu hủy chuyến trong vòng trên 5 ngày trước chuyến đi theo quy chế e-Motion.',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text, {this.horizontalPadding = 6});

  final String text;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  const _DataCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF475569),
        ),
      ),
    );
  }
}
