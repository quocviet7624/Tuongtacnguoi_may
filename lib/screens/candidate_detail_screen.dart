import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/global_data.dart';
import '../models/user_model.dart';
import '../models/job_model.dart';

class CandidateDetailScreen extends StatelessWidget {
  const CandidateDetailScreen({super.key});

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2)
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  Color _getColor(String name) {
    final colors = [
      const Color(0xFF1976D2),
      const Color(0xFF00B14F),
      const Color(0xFFEB7E35),
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
      const Color(0xFF00796B),
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>;
    final AppUser candidate = args['user'] as AppUser;
    final Job job = args['job'] as Job;

    // ✅ Dùng displayName getter — không bao giờ null
    final displayName = candidate.displayName;
    final avatarColor = _getColor(displayName);
    final userProvider =
        Provider.of<UserProvider>(context, listen: false);

    void openChat() {
      final currentUser = userProvider.currentUser!;
      final convId = GlobalData.getOrCreateConversationId(
        currentUser.email,
        candidate.email,
        job.title,
      );
      Navigator.pushNamed(
        context,
        '/chat-detail',
        arguments: {
          'id': convId,
          'participant1': currentUser.email,
          'participant2': candidate.email,
          'jobTitle': job.title,
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color(0xFF1F2937), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hồ sơ ứng viên',
          style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header card ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                  vertical: 28, horizontal: 20),
              child: Column(
                children: [
                  // ✅ Dùng avatarFile getter từ model
                  candidate.avatarFile != null
                      ? CircleAvatar(
                          radius: 44,
                          backgroundImage:
                              FileImage(candidate.avatarFile!),
                        )
                      : CircleAvatar(
                          radius: 44,
                          backgroundColor: avatarColor,
                          child: Text(
                            _getInitials(displayName),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    candidate.email,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF9CA3AF)),
                  ),
                  // ✅ Dùng ?. để check phone nullable
                  if (candidate.phone?.isNotEmpty == true) ...[
                    const SizedBox(height: 2),
                    Text(
                      candidate.phone!,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Ứng tuyển: ${job.title}',
                      style: const TextStyle(
                          color: Color(0xFFEB7E35),
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── Học vấn ───────────────────────────────────────────────────
            _Section(
              title: 'Thông tin học vấn',
              children: [
                _Row(
                    icon: Icons.school_outlined,
                    label: 'Trường',
                    value: candidate.school ?? 'Chưa cập nhật'),
                _Row(
                    icon: Icons.book_outlined,
                    label: 'Ngành',
                    value: candidate.major ?? 'Chưa cập nhật'),
                if (candidate.gpa != null)
                  _Row(
                    icon: Icons.star_outline,
                    label: 'GPA',
                    value: candidate.gpa!.toStringAsFixed(2),
                    valueColor: const Color(0xFFEAB308),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Kỹ năng ───────────────────────────────────────────────────
            if (candidate.skills != null &&
                candidate.skills!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kỹ năng',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827)),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: candidate.skills!.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F9FF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFBAE6FD)),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF0369A1),
                                fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // ── Kỳ vọng lương ─────────────────────────────────────────────
            if (candidate.salaryMin != null ||
                candidate.salaryMax != null) ...[
              _Section(
                title: 'Kỳ vọng lương',
                children: [
                  _Row(
                    icon: Icons.payments_outlined,
                    label: 'Mức lương',
                    value: _formatSalary(
                        candidate.salaryMin, candidate.salaryMax),
                  ),
                  if (candidate.availableTime != null &&
                      candidate.availableTime!.isNotEmpty)
                    _Row(
                      icon: Icons.access_time_outlined,
                      label: 'Thời gian có thể làm',
                      value: candidate.availableTime!.join(', '),
                    ),
                ],
              ),
              const SizedBox(height: 10),
            ],

            // ── Vị trí ứng tuyển ──────────────────────────────────────────
            _Section(
              title: 'Thông tin việc làm ứng tuyển',
              children: [
                _Row(
                    icon: Icons.work_outline,
                    label: 'Vị trí',
                    value: job.title),
                _Row(
                    icon: Icons.business_outlined,
                    label: 'Công ty',
                    value: job.company),
                _Row(
                    icon: Icons.location_on_outlined,
                    label: 'Địa điểm',
                    value: job.location),
                _Row(
                    icon: Icons.attach_money,
                    label: 'Lương',
                    value: job.salary),
              ],
            ),

            const SizedBox(height: 20),

            // ── Actions ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: openChat,
                      icon: const Icon(Icons.chat_bubble_outline,
                          size: 18),
                      label: const Text('Nhắn tin',
                          style:
                              TextStyle(fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEB7E35),
                        side: const BorderSide(
                            color: Color(0xFFEB7E35)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      // ✅ displayName là String, không cần ép kiểu
                      onPressed: () =>
                          _showInterviewDialog(context, displayName),
                      icon: const Icon(Icons.calendar_today,
                          size: 18, color: Colors.white),
                      label: const Text(
                        'Hẹn phỏng vấn',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String _formatSalary(double? min, double? max) {
    if (min == null && max == null) return 'Thỏa thuận';
    if (min != null && max != null)
      return '${_fmt(min)} - ${_fmt(max)} VNĐ/giờ';
    if (min != null) return 'Từ ${_fmt(min)} VNĐ/giờ';
    return 'Đến ${_fmt(max!)} VNĐ/giờ';
  }

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }

  void _showInterviewDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text('Hẹn phỏng vấn với $name'),
        content: const Text(
            'Chức năng đặt lịch phỏng vấn. Bạn muốn xem lịch phỏng vấn?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/interview-schedule');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB7E35),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Xem lịch',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827)),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _Row({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}