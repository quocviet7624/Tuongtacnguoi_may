import 'package:flutter/material.dart';

class InterviewScheduleScreen extends StatefulWidget {
  const InterviewScheduleScreen({super.key});
  @override
  State<InterviewScheduleScreen> createState() =>
      _InterviewScheduleScreenState();
}

class _InterviewScheduleScreenState extends State<InterviewScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDay = 16;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EDF0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A6FA8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Lịch phỏng vấn',
              style: TextStyle(
                  color: Color(0xFFBCDCEE),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter'),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF92C2E2),
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Lịch Phỏng Vấn'),
            Tab(text: 'Nhật Ký Làm Việc'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _InterviewCalendarTab(
            selectedDay: _selectedDay,
            onDaySelected: (d) => setState(() => _selectedDay = d),
          ),
          const _WorkLogTab(),
        ],
      ),
    );
  }
}

class _InterviewCalendarTab extends StatelessWidget {
  final int selectedDay;
  final ValueChanged<int> onDaySelected;
  const _InterviewCalendarTab(
      {required this.selectedDay, required this.onDaySelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: const Color(0xFF1A6FA8),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Center(
              child: Text(
                'Tháng 10.2024',
                style: TextStyle(
                    color: Color(0xFF6C7178),
                    fontSize: 20,
                    fontFamily: 'Inter'),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                      .map((d) => Expanded(
                            child: Center(
                              child: Text(d,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF8A8F98),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter')),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                ..._buildCalendarRows(selectedDay, onDaySelected),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'PHỎNG VẤN SẮP TỚI',
                  style: TextStyle(
                      color: Color(0xFFD47B4F),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter'),
                ),
                SizedBox(height: 12),
                _InfoRow(
                    icon: Icons.work_outline,
                    text: 'Vị Trí: Nhân viên Marketing'),
                SizedBox(height: 8),
                _InfoRow(
                    icon: Icons.business, text: 'Công ty: Công ty XYZ Tech'),
                SizedBox(height: 8),
                _InfoRow(
                    icon: Icons.access_time,
                    text: 'Thời gian: 16/10/2024 | 9:00-10:30 SA'),
                SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  text:
                      'Địa điểm: Tầng 5, Tòa nhà Millennium, 456 Đường Nguyễn Chí Thanh',
                ),
                SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.person_outline,
                  text:
                      'Liên hệ: Anh Lê Văn Hoàng | 0911223344 | lv.c@xyztech.vn',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCalendarRows(int selected, ValueChanged<int> onTap) {
    final days = [
      [30, 1, 2, 3, 4, 5, 6],
      [7, 8, 9, 10, 11, 12, 13],
      [14, 15, 16, 17, 18, 19, 20],
      [21, 22, 23, 24, 25, 26, 27],
      [28, 29, 30, 31, null, null, null],
    ];
    return days.map((week) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: week.map((d) {
            if (d == null) return const Expanded(child: SizedBox());
            final isSelected = d == selected;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(d),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFA640C)
                        : const Color(0xFFF3F4F5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      '$d',
                      style: TextStyle(
                          fontSize: 15,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF78797F),
                          fontFamily: 'Inter'),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }).toList();
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF858589)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF858589),
                  fontFamily: 'Inter')),
        ),
      ],
    );
  }
}

class _WorkLogTab extends StatelessWidget {
  const _WorkLogTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF1A6FA8),
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('TỔNG GIỜ LÀM\nTHÁNG NÀY',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter')),
                    SizedBox(height: 8),
                    Text('48 GIỜ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter')),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('ƯỚC TÍNH THU NHẬP',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter')),
                    SizedBox(height: 8),
                    Text('1.200.000đ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter')),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('THÁNG 10 • 2024',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: 'Inter')),
                const SizedBox(height: 16),
                Row(
                  children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                      .map((d) => Expanded(
                            child: Center(
                              child: Text(d,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF4B5563),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter')),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                ..._buildWorkLogCalendar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWorkLogCalendar() {
    final weeks = [
      [1, 2, 3, 4, 5, 6, 7],
      [8, 9, 10, 11, 12, 13, 14],
      [15, 16, 17, 18, 19, 20, 21],
      [22, 23, 24, 25, 26, 27, 28],
      [29, 30, 31, null, null, null, null],
    ];
    const workDays = {5, 12, 19, 26};

    return weeks.map((week) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: week.map((d) {
            if (d == null) return const Expanded(child: SizedBox());
            final isWork = workDays.contains(d);
            return Expanded(
              child: Container(
                margin: const EdgeInsets.all(2),
                height: 36,
                decoration: BoxDecoration(
                  color: isWork
                      ? const Color(0xFFEB7E35)
                      : const Color(0xFFF3F4F5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    '$d',
                    style: TextStyle(
                        fontSize: 14,
                        color:
                            isWork ? Colors.white : const Color(0xFF111827),
                        fontFamily: 'Inter'),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }).toList();
  }
}