import 'package:flutter/material.dart';

class JobFilterScreen extends StatefulWidget {
  const JobFilterScreen({super.key});

  @override
  State<JobFilterScreen> createState() => _JobFilterScreenState();
}

class _JobFilterScreenState extends State<JobFilterScreen> {
  // ── State bộ lọc ──────────────────────────────────────────────
  String _selectedType = 'Full-time'; // Full-time | Part-time | Freelance
  double _salaryMin = 15000;
  double _salaryMax = 100000;
  final Set<String> _selectedAreas = {};
  final Set<String> _selectedShifts = {};

  final List<String> _areas = [
    'Hải Châu',
    'Thanh Khê',
    'Liên Chiểu',
    'Cẩm Lệ',
    'Sơn Trà',
    'Ngũ Hành Sơn',
  ];

  final List<String> _shifts = ['Sáng', 'Chiều', 'Tối'];

  String _formatMoney(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v ~/ 1000)}K';
    return '${v.toInt()}đ';
  }

  void _apply() {
    final filter = {
      'type': _selectedType,
      'salaryMin': _salaryMin,
      'salaryMax': _salaryMax,
      'areas': _selectedAreas.toList(),
      'shifts': _selectedShifts.toList(),
    };
    Navigator.pop(context, filter);
  }

  void _reset() {
    setState(() {
      _selectedType = 'Full-time';
      _salaryMin = 15000;
      _salaryMax = 100000;
      _selectedAreas.clear();
      _selectedShifts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ── AppBar ────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bộ lọc tìm kiếm',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _reset,
            child: const Text(
              'Đặt lại',
              style: TextStyle(
                color: Color(0xFF004E94),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Danh mục (loại công việc) ─────────────────
                  _SectionTitle('Danh mục'),
                  const SizedBox(height: 10),
                  Row(
                    children: ['Full-time', 'Part-time', 'Freelance']
                        .map((t) => _TypeChip(
                              label: t,
                              selected: _selectedType == t,
                              onTap: () => setState(() => _selectedType = t),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 28),

                  // ── Mức lương ─────────────────────────────────
                  _SectionTitle('Mức lương'),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatMoney(_salaryMin),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF004E94),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        '${_formatMoney(_salaryMax)}/giờ',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF004E94),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(_salaryMin, _salaryMax),
                    min: 15000,
                    max: 100000,
                    divisions: 17,
                    activeColor: const Color(0xFF004E94),
                    inactiveColor: const Color(0xFFD5D5D5),
                    onChanged: (v) => setState(() {
                      _salaryMin = v.start;
                      _salaryMax = v.end;
                    }),
                  ),

                  const SizedBox(height: 24),

                  // ── Khu vực ───────────────────────────────────
                  _SectionTitle('Khu vực'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _areas.map((a) {
                      final selected = _selectedAreas.contains(a);
                      return GestureDetector(
                        onTap: () => setState(() {
                          selected
                              ? _selectedAreas.remove(a)
                              : _selectedAreas.add(a);
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF004E94)
                                : const Color(0xFFD5D5D5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            a,
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // ── Ca làm ────────────────────────────────────
                  _SectionTitle('Ca làm'),
                  const SizedBox(height: 10),
                  Row(
                    children: _shifts.map((s) {
                      final selected = _selectedShifts.contains(s);
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            selected
                                ? _selectedShifts.remove(s)
                                : _selectedShifts.add(s);
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF004E94)
                                  : const Color(0xFFD5D5D5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              s,
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Nút áp dụng ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004E94),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Áp dụng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget phụ ──────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF004E94)
                : const Color(0xFFD5D5D5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}