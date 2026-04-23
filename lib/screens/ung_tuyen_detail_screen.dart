// screens/ung_tuyen_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/job_model.dart';

class UngTuyenDetailScreen extends StatelessWidget {
  final Job job;

  const UngTuyenDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFA9D0E9)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chi tiết ứng tuyển',
          style: TextStyle(
            color: Color(0xFFA9D0E9),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 20),
            _buildJobInfoCard(),
            const SizedBox(height: 20),
            _buildTimelineCard(),
            const SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEB7E35), Color(0xFFEBBA1B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEB7E35).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.hourglass_top_rounded,
              color: Colors.white, size: 40),
          const SizedBox(height: 8),
          const Text(
            'Đang xem xét',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hồ sơ của bạn đang được nhà tuyển dụng xem xét',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildJobInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          const BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin công việc',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const Divider(height: 20),
          _buildInfoRow(Icons.work_outline, 'Vị trí', job.title),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.business_outlined, 'Công ty', job.company),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.attach_money_outlined, 'Mức lương', job.salary),
          if (job.location != null && job.location!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
                Icons.location_on_outlined, 'Địa điểm', job.location!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFFEB7E35)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade500)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineCard() {
    final steps = [
      _TimelineStep(
        label: 'Đã nộp hồ sơ',
        subtitle: 'Hồ sơ đã gửi thành công',
        icon: Icons.check_circle,
        isCompleted: true,
      ),
      _TimelineStep(
        label: 'Đang xem xét',
        subtitle: 'Nhà tuyển dụng đang xem xét',
        icon: Icons.hourglass_top_rounded,
        isCompleted: false,
        isActive: true,
      ),
      _TimelineStep(
        label: 'Phỏng vấn',
        subtitle: 'Chờ xác nhận lịch',
        icon: Icons.event_available_outlined,
        isCompleted: false,
      ),
      _TimelineStep(
        label: 'Kết quả',
        subtitle: 'Chưa có kết quả',
        icon: Icons.emoji_events_outlined,
        isCompleted: false,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tiến trình ứng tuyển',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(steps.length, (i) {
            final step = steps[i];
            final isLast = i == steps.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: step.isCompleted
                            ? const Color(0xFFEB7E35)
                            : step.isActive
                                ? const Color(0xFFEBBA1B)
                                : Colors.grey.shade200,
                      ),
                      child: Icon(
                        step.icon,
                        size: 18,
                        color: (step.isCompleted || step.isActive)
                            ? Colors.white
                            : Colors.grey.shade400,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 36,
                        color: step.isCompleted
                            ? const Color(0xFFEB7E35)
                            : Colors.grey.shade200,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.label,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: (step.isCompleted || step.isActive)
                                ? const Color(0xFF333333)
                                : Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          step.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/job-detail', arguments: job);
            },
            icon: const Icon(Icons.visibility_outlined,
                color: Color(0xFFEB7E35)),
            label: const Text(
              'Xem tin tuyển dụng',
              style: TextStyle(color: Color(0xFFEB7E35)),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFFEB7E35)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/chat-detail');
            },
            icon: const Icon(Icons.chat_bubble_outline,
                color: Color(0xFFA9D0E9)),
            label: const Text(
              'Nhắn tin với nhà tuyển dụng',
              style: TextStyle(color: Color(0xFFA9D0E9)),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFFA9D0E9)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineStep {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool isCompleted;
  final bool isActive;

  _TimelineStep({
    required this.label,
    required this.subtitle,
    required this.icon,
    this.isCompleted = false,
    this.isActive = false,
  });
}