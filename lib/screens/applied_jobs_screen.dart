import 'package:flutter/material.dart';

class AppliedJobsScreen extends StatelessWidget {
  const AppliedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new,
                        size: 22, color: Color(0xFFA9D0E9)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Việc làm đã ứng tuyển',
                    style: TextStyle(
                      color: Color(0xFFA9D0E9),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Job application list
            Expanded(
              child: ListView(
                children: [
                  _buildApplicationItem(
                    context: context,
                    jobTitle: 'Nhân viên Marketing',
                    company: 'Công ty ABC Media',
                    status: 'Đang xem xét',
                    statusColor: const Color(0xFFEBBA1B),
                  ),
                  const Divider(color: Color(0xFFE0E0E1), height: 1),
                  _buildApplicationItem(
                    context: context,
                    jobTitle: 'Lập trình viên iOS',
                    company: 'Công ty XYZ Tech',
                    status: 'Phỏng vấn',
                    statusColor: const Color(0xFF3588E5),
                  ),
                  const Divider(color: Color(0xFFE0E1DF), height: 1),
                  _buildApplicationItem(
                    context: context,
                    jobTitle: 'Thư ký văn phòng',
                    company: 'Công ty QRS Services',
                    status: 'Đã nhận',
                    statusColor: const Color(0xFF27A766),
                  ),
                  const Divider(color: Color(0xFFDFDFDF), height: 1),
                  _buildApplicationItem(
                    context: context,
                    jobTitle: 'Nhân viên kinh doanh',
                    company: 'Công ty LMN Trading',
                    status: 'Từ chối',
                    statusColor: const Color(0xFFDC2E2D),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationItem({
    required BuildContext context,
    required String jobTitle,
    required String company,
    required String status,
    required Color statusColor,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/apply-detail'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            // Job info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobTitle,
                    style: const TextStyle(
                      color: Color(0xFF464646),
                      fontSize: 22,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    company,
                    style: const TextStyle(
                      color: Color(0xFF898A8C),
                      fontSize: 17,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: ShapeDecoration(
                color: statusColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1, color: statusColor.withOpacity(0.7)),
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}