import 'package:flutter/material.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  children: [
                    Container(
                      width: 73,
                      height: 78,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.business, size: 40, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MOBITECH JSC',
                            style: TextStyle(
                              color: Color(0xFF040797),
                              fontSize: 28,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.30,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              ...List.generate(
                                  5,
                                  (_) => const Icon(Icons.star,
                                      color: Colors.amber, size: 16)),
                              const SizedBox(width: 6),
                              const Text(
                                '5.0 (120 đánh giá)',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Address
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 12, 24, 0),
                child: Row(
                  children: const [
                    Icon(Icons.location_on_outlined, size: 18, color: Colors.black54),
                    SizedBox(width: 4),
                    Text(
                      '123 đ. Lê Lợi, TP.Hồ Chí Minh',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Về công ty
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Text(
                  'Về công ty',
                  style: TextStyle(
                    color: Color(0xFF040797),
                    fontSize: 28,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: const Text(
                  'Công ty phát triển ứng dụng di động chuyên nghiệp, tập trung vào giải pháp công nghệ cho doanh nghiệp. Với đội ngũ kinh nghiệm, chúng tôi tạo sản phẩm chất lượng cao cho khách hàng trên toàn quốc.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.30,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Các việc làm đang tuyển
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Text(
                  'Các việc làm đang tuyển',
                  style: TextStyle(
                    color: Color(0xFFFF5D00),
                    fontSize: 28,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.30,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              _buildJobItem(
                context: context,
                title: 'Nhân viên phát triển iOS',
                type: 'Full-time | Lương 15 - 20 triệu/ tháng',
                requirement: 'Yêu cầu: Kinh nghiệm Swift > 2 năm, phát triển app iOS',
              ),
              _buildJobItem(
                context: context,
                title: 'Nhân viên thiết kế UI/UX',
                type: 'Full-time | Lương 14 - 18 triệu/ tháng',
                requirement: 'Yêu cầu: Kinh nghiệm Figma, thiết kế giao diện app di động',
              ),
              _buildJobItem(
                context: context,
                title: 'Nhân viên Marketing Digital',
                type: 'Full-time | Lương 12 - 16 triệu/ tháng',
                requirement: 'Yêu cầu: Kinh nghiệm quảng cáo social media, content',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobItem({
    required BuildContext context,
    required String title,
    required String type,
    required String requirement,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 0, 13, 12),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/job-detail'),
        child: Container(
          height: 120,
          decoration: ShapeDecoration(
            color: const Color(0xFFD9D9D9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF6364BE),
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.30,
                  ),
                ),
                const SizedBox(height: 4),
                Text(type,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(requirement,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}