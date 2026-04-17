import 'package:flutter/material.dart';

class JobFilterScreen extends StatefulWidget {
  const JobFilterScreen({super.key});

  @override
  State<JobFilterScreen> createState() => _JobFilterScreenState();
}

class _JobFilterScreenState extends State<JobFilterScreen> {
  String selectedJobType = 'Full-time';
  RangeValues salaryRange = const RangeValues(15000, 100000);
  String selectedArea = '';
  String selectedShift = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background job list (blurred effect simulation)
            Opacity(
              opacity: 0.3,
              child: Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 16, 25, 0),
                    child: Container(
                      height: 63,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF9FAF7),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFF858585)),
                          borderRadius: BorderRadius.circular(36),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter panel
            Positioned(
              left: 25,
              top: 94,
              right: 25,
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Center(
                        child: Text(
                          'Bộ lọc tìm kiếm',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Danh mục
                      const Text(
                        'Danh mục',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildTypeChip('Full-time'),
                          const SizedBox(width: 8),
                          _buildTypeChip('Part-time'),
                          const SizedBox(width: 8),
                          _buildTypeChip('Freelance'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Mức lương
                      const Text(
                        'Mức lương',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('15.000đ',
                              style: TextStyle(fontSize: 14, fontFamily: 'Inter')),
                          const Text('100.000đ/giờ',
                              style: TextStyle(fontSize: 14, fontFamily: 'Inter')),
                        ],
                      ),
                      RangeSlider(
                        values: salaryRange,
                        min: 0,
                        max: 120000,
                        activeColor: const Color(0xFF004E94),
                        onChanged: (v) => setState(() => salaryRange = v),
                      ),
                      const SizedBox(height: 8),

                      // Khu vực
                      const Text(
                        'Khu vực',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['Hải Châu', 'Thanh Khê', 'Liên Chiểu', 'Cẩm Lệ']
                            .map((a) => _buildAreaChip(a))
                            .toList(),
                      ),
                      const SizedBox(height: 16),

                      // Ca làm
                      const Text(
                        'Ca làm',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildShiftChip('Sáng'),
                          const SizedBox(width: 8),
                          _buildShiftChip('Chiều'),
                          const SizedBox(width: 8),
                          _buildShiftChip('Tối'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Apply button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: const BoxDecoration(
                            color: Color(0xFF004E94),
                          ),
                          child: const Center(
                            child: Text(
                              'Áp dụng',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                                letterSpacing: -0.30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label) {
    final isSelected = selectedJobType == label;
    return GestureDetector(
      onTap: () => setState(() => selectedJobType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF004E94) : const Color(0xFFD5D5D5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 15,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget _buildAreaChip(String label) {
    final isSelected = selectedArea == label;
    return GestureDetector(
      onTap: () => setState(() => selectedArea = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF004E94) : const Color(0xFFD5D5D5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 15,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget _buildShiftChip(String label) {
    final isSelected = selectedShift == label;
    return GestureDetector(
      onTap: () => setState(() => selectedShift = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF004E94) : const Color(0xFFD5D5D5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 15,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}