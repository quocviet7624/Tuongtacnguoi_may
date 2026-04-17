import 'package:flutter/material.dart';

class HoSoUVScreen extends StatelessWidget {
  const HoSoUVScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, size: 22, color: Color(0xFF111111)),
                    ),
                    const Expanded(
                      child: Text(
                        'HỒ SƠ ỨNG VIÊN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(width: 22),
                  ],
                ),
              ),

              // Avatar + Info
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 44,
                backgroundColor: const Color(0xFFEB7E35),
                child: const Text(
                  'NVA',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'NGUYỄN VĂN A',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sinh viên Kinh tế | ĐHQG Hà Nội',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
              const Text(
                'Tuổi: 22 | Thành phố: Hà Nội',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),

              const SizedBox(height: 24),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              // Tỷ lệ khớp kỹ năng
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TỶ LỆ KHỚP KỸ NĂNG',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tổng khớp: 81%',
                      style: TextStyle(fontSize: 14, color: Color(0xFFFF8A00), fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    _buildSkillRow('Kinh doanh', 0.88),
                    const SizedBox(height: 8),
                    _buildSkillRow('Phân tích dữ liệu', 0.75),
                    const SizedBox(height: 8),
                    _buildSkillRow('Tiếng Anh', 0.80),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              // Xem CV trước
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'XEM CV TRƯỚC',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                    const SizedBox(height: 12),
                    _buildCVSection('Học vấn:', 'ĐHQG Hà Nội - Kinh tế (2021-2025)'),
                    const SizedBox(height: 12),
                    _buildCVSection('Kinh nghiệm:', 'Thực tập sinh Kinh doanh - Công ty ABC'),
                    const SizedBox(height: 12),
                    _buildCVSection('Kỹ năng:', 'Excel, PowerPoint, Phân tích dữ liệu, Tiếng Anh B2'),
                    const SizedBox(height: 12),
                    _buildCVSection('Mục tiêu:', 'Tìm kiếm vị trí thực tập/part-time trong lĩnh vực kinh doanh và marketing'),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/chat-detail'),
                        icon: const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.white),
                        label: const Text('NHẮN TIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEB7E35),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showInterviewDialog(context),
                        icon: const Icon(Icons.calendar_today, size: 18, color: Colors.white),
                        label: const Text('HẸN PHỎNG VẤN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillRow(String skill, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(skill, style: const TextStyle(fontSize: 13, color: Colors.black)),
            Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 13, color: Color(0xFFFF8A00))),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: const Color(0xFFEEEEEE),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF8A00)),
          ),
        ),
      ],
    );
  }

  Widget _buildCVSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF666666))),
      ],
    );
  }

  void _showInterviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hẹn phỏng vấn'),
        content: const Text('Chọn thời gian phỏng vấn với Nguyễn Văn A?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã gửi lời mời phỏng vấn!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEB7E35)),
            child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}