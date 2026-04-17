import 'package:flutter/material.dart';

class ApplyDetailScreen extends StatelessWidget {
  const ApplyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 20, color: Color(0xFFA6CEE7)),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'CHI TIẾT ỨNG TUYỂN',
                      style: TextStyle(
                        color: Color(0xFFA6CEE7),
                        fontSize: 21,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Thông tin việc làm
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.info_outline, size: 20, color: Color(0xFF575757)),
                        SizedBox(width: 8),
                        Text(
                          'THÔNG TIN VIỆC LÀM',
                          style: TextStyle(
                            color: Color(0xFF575757),
                            fontSize: 17,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Vị trí: Nhân viên Kinh Doanh\n'
                      'Công ty: Công Ty ABC\n'
                      'Ngày nộp: 12/10/2024',
                      style: TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 17,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.74,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Trạng thái ứng tuyển
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.track_changes, size: 20, color: Color(0xFF50504F)),
                    SizedBox(width: 8),
                    Text(
                      'TRẠNG THÁI ỨNG TUYỂN',
                      style: TextStyle(
                        color: Color(0xFF50504F),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Timeline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildTimelineItem(
                      label: 'Đã nộp',
                      icon: Icons.send,
                      isActive: true,
                      isHighlighted: false,
                    ),
                    _buildTimelineLine(),
                    _buildTimelineItem(
                      label: 'Đang xét duyệt',
                      icon: Icons.hourglass_empty,
                      isActive: true,
                      isHighlighted: true,
                    ),
                    _buildTimelineLine(),
                    _buildTimelineItem(
                      label: 'Phỏng vấn',
                      icon: Icons.people_outline,
                      isActive: false,
                      isHighlighted: false,
                    ),
                    _buildTimelineLine(),
                    _buildTimelineItem(
                      label: 'Kết quả',
                      icon: Icons.check_circle_outline,
                      isActive: false,
                      isHighlighted: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Thông điệp từ công ty
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.mail_outline, size: 20, color: Color(0xFF525252)),
                    SizedBox(width: 8),
                    Text(
                      'THÔNG ĐIỆP TỪ CÔNG TY',
                      style: TextStyle(
                        color: Color(0xFF525252),
                        fontSize: 17,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: const Color(0xFFE6E7E4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                        SizedBox(width: 6),
                        Text(
                          'Từ: Công Ty ABC',
                          style: TextStyle(
                            color: Color(0xFF7D7D7B),
                            fontSize: 15,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Chào bạn,\n'
                      'Chúng tôi đang xét duyệt hồ sơ ứng tuyển của bạn. '
                      'Chúng tôi sẽ liên hệ bạn sớm nhất khi có thông tin mới\n'
                      'Trân Trọng\n'
                      'Bộ phận tuyển dụng',
                      style: TextStyle(
                        color: Color(0xFF71716F),
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String label,
    required IconData icon,
    required bool isActive,
    required bool isHighlighted,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isHighlighted
                ? const Color(0xFFEFB88F)
                : isActive
                    ? Colors.green.shade100
                    : Colors.grey.shade200,
            shape: BoxShape.circle,
            border: isHighlighted
                ? Border.all(color: const Color(0xFFE38E55), width: 3)
                : null,
          ),
          child: Icon(icon,
              size: 18,
              color: isHighlighted
                  ? const Color(0xFFCA6532)
                  : isActive
                      ? Colors.green
                      : Colors.grey),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: isHighlighted
                ? const Color(0xFFCA6532)
                : const Color(0xFF747473),
            fontSize: 17,
            fontFamily: 'Inter',
            fontWeight:
                isHighlighted ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        width: 2,
        height: 28,
        color: Colors.grey.shade300,
      ),
    );
  }
}