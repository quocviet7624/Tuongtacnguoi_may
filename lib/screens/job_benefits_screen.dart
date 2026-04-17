import 'package:flutter/material.dart';

class JobBenefitsScreen extends StatelessWidget {
  const JobBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quyền lợi
              _buildSectionHeader('Quyền lợi'),
              const SizedBox(height: 12),
              _buildBenefitItem('Bảo hiểm y tế'),
              _buildBenefitItem('Thưởng tháng 13'),
              _buildBenefitItem('Hỗ trợ chi phí ăn trưa'),
              _buildBenefitItem('Đào tạo chuyên môn miễn phí'),
              const SizedBox(height: 24),

              // Lịch làm việc
              _buildSectionHeader('Lịch làm việc'),
              const SizedBox(height: 12),
              _buildScheduleRow('Thứ 2 - 6:', '8:00-17:00'),
              _buildScheduleRow('Thứ 7:', 'Nghỉ'),
              _buildScheduleRow('Ngày lễ:', 'Nghỉ có lương'),
              const SizedBox(height: 24),

              // Đánh giá nhà tuyển dụng
              _buildSectionHeader('Đánh giá nhà tuyển dụng'),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const Icon(Icons.star_half, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    '4.0/5 (28 đánh giá)',
                    style: TextStyle(
                      color: Color(0xFF000B59),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildReview('Hạnh', 'Môi trường làm việc tốt, đồng nghiệp thân thiện!', 5),
              const SizedBox(height: 8),
              _buildReview('Minh', 'Lương trả đúng hạn, hỗ trợ tốt', 4),
              const SizedBox(height: 24),

              // Việc làm tương tự
              _buildSectionHeader('Việc làm tương tự'),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildSimilarJob('Part-Time thu ngân', 'Cửa hàng Highlands', '160k/giờ'),
                    const SizedBox(width: 8),
                    _buildSimilarJob('Intern Kỹ thuật', 'Công ty ABC', '5tr/tháng'),
                    const SizedBox(width: 8),
                    _buildSimilarJob('Part-Time Giao hàng', 'Gojek', '22k/đơn'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Apply button
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/ung-tuyen'),
                child: Container(
                  width: double.infinity,
                  height: 65,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFF7526),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Ứng tuyển ngay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
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
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF000C7E),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF000C7E),
            fontSize: 28,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.30,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF000C7E), size: 22),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF000B59),
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              day,
              style: const TextStyle(
                color: Color(0xFF000B59),
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFF000B59),
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReview(String name, String comment, int stars) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.account_circle, size: 32, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$name: ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Inter'),
                    ),
                    ...List.generate(
                        stars,
                        (_) => const Icon(Icons.star,
                            color: Colors.amber, size: 16)),
                  ],
                ),
                Text(comment,
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Inter',
                        color: Color(0xFF000B59))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarJob(String title, String company, String salary) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: const Color(0xFFD9D9D9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF000C7E),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(company,
              style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Inter',
                  color: Color(0xFF000C7E),
                  fontWeight: FontWeight.w300)),
          const SizedBox(height: 6),
          Text(salary,
              style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  color: Color(0xFFFF7626),
                  fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}