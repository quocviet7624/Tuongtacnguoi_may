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
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
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

  String _formatSalary(double? min, double? max) {
    String fmt(double v) {
      if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
      if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
      return v.toStringAsFixed(0);
    }

    if (min == null && max == null) return 'Thỏa thuận';
    if (min != null && max != null) return '${fmt(min)} - ${fmt(max)} VNĐ';
    if (min != null) return 'Từ ${fmt(min)} VNĐ';
    return 'Đến ${fmt(max!)} VNĐ';
  }

  String _currentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final AppUser candidate = args['user'] as AppUser;
    final Job job = args['job'] as Job;

    // ✅ Sử dụng getter displayName (luôn non-null)
    final displayName = candidate.displayName;
    final avatarColor = _getColor(displayName);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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
          'name': displayName,
          'avatar': _getInitials(displayName),
          'avatarColor': avatarColor,
          'isOnline': false,
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
            // ── Avatar + tên ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              child: Column(
                children: [
                  candidate.avatarFile != null
                      ? CircleAvatar(
                          radius: 44,
                          backgroundImage: FileImage(candidate.avatarFile!),
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
                  Text(candidate.email,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF9CA3AF))),
                  // ✅ Fix null check cho phone
                  if (candidate.phone != null &&
                      candidate.phone!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(candidate.phone!,
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF9CA3AF))),
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
                _InfoRow(
                    icon: Icons.school_outlined,
                    label: 'Trường',
                    value: candidate.school ?? 'Chưa cập nhật'),
                _InfoRow(
                    icon: Icons.book_outlined,
                    label: 'Ngành',
                    value: candidate.major ?? 'Chưa cập nhật'),
                if (candidate.gpa != null)
                  _InfoRow(
                    icon: Icons.star_outline,
                    label: 'GPA',
                    value: candidate.gpa!.toStringAsFixed(2),
                    valueColor: const Color(0xFFEAB308),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Kỹ năng ───────────────────────────────────────────────────
            if (candidate.skills != null && candidate.skills!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kỹ năng',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827))),
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
                            border:
                                Border.all(color: const Color(0xFFBAE6FD)),
                          ),
                          child: Text(skill,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF0369A1),
                                  fontWeight: FontWeight.w500)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // ── Kỳ vọng lương ─────────────────────────────────────────────
            if (candidate.salaryMin != null || candidate.salaryMax != null) ...[
              _Section(
                title: 'Kỳ vọng',
                children: [
                  _InfoRow(
                    icon: Icons.payments_outlined,
                    label: 'Mức lương',
                    value: _formatSalary(
                        candidate.salaryMin, candidate.salaryMax),
                  ),
                  if (candidate.availableTime != null &&
                      candidate.availableTime!.isNotEmpty)
                    _InfoRow(
                      icon: Icons.access_time_outlined,
                      label: 'Thời gian',
                      value: candidate.availableTime!.join(', '),
                    ),
                ],
              ),
              const SizedBox(height: 10),
            ],

            // ── Vị trí ứng tuyển ──────────────────────────────────────────
            _Section(
              title: 'Vị trí ứng tuyển',
              children: [
                _InfoRow(
                    icon: Icons.work_outline,
                    label: 'Vị trí',
                    value: job.title),
                _InfoRow(
                    icon: Icons.business_outlined,
                    label: 'Công ty',
                    value: job.company),
                _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Địa điểm',
                    value: job.location),
                _InfoRow(
                    icon: Icons.attach_money,
                    label: 'Lương',
                    value: job.salary),
              ],
            ),

            const SizedBox(height: 20),

            // ── Nút hành động ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: openChat,
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: const Text('Nhắn tin',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEB7E35),
                        side: const BorderSide(color: Color(0xFFEB7E35)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showInterviewDialog(
                          context, candidate, job, displayName, userProvider),
                      icon: const Icon(Icons.calendar_today,
                          size: 18, color: Colors.white),
                      label: const Text('Hẹn phỏng vấn',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
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

  // ── Dialog hẹn phỏng vấn ─────────────────────────────────────────────────
  void _showInterviewDialog(
    BuildContext context,
    AppUser candidate,
    Job job,
    String displayName, // ✅ luôn là String, không null
    UserProvider userProvider,
  ) {
    final dateCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final currentUser = userProvider.currentUser;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Hẹn phỏng vấn với $displayName',
          style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogField(
                  controller: dateCtrl,
                  label: 'Ngày phỏng vấn *',
                  hint: 'VD: 20/05/2026',
                  icon: Icons.calendar_today),
              const SizedBox(height: 12),
              _DialogField(
                  controller: timeCtrl,
                  label: 'Giờ phỏng vấn *',
                  hint: 'VD: 9:00 - 10:00',
                  icon: Icons.access_time),
              const SizedBox(height: 12),
              _DialogField(
                  controller: locationCtrl,
                  label: 'Địa điểm *',
                  hint: 'VD: Tầng 3, Tòa nhà ABC, Đà Nẵng',
                  icon: Icons.location_on_outlined),
              const SizedBox(height: 12),
              _DialogField(
                  controller: noteCtrl,
                  label: 'Ghi chú (tùy chọn)',
                  hint: 'VD: Mang theo CV bản cứng',
                  icon: Icons.note_outlined),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              // ✅ Validate
              if (dateCtrl.text.trim().isEmpty ||
                  timeCtrl.text.trim().isEmpty ||
                  locationCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng điền đủ ngày, giờ và địa điểm!'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              final noteText = noteCtrl.text.trim();

              // ✅ Tạo object lịch phỏng vấn
              final interview = {
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'candidateEmail': candidate.email,
                'candidateName': displayName,
                'employerEmail': currentUser?.email ?? '',
                'companyName': currentUser?.companyName ??
                    currentUser?.fullName ??
                    '',
                'jobTitle': job.title,
                'date': dateCtrl.text.trim(),
                'time': timeCtrl.text.trim(),
                'location': locationCtrl.text.trim(),
                'note': noteText,
                'status': 'Chờ xác nhận',
                'createdAt': DateTime.now().toIso8601String(),
              };

              // ✅ Lưu vào GlobalData
              await GlobalData.addInterview(interview);

              // ✅ Gửi tin nhắn thông báo qua chat
              final convId = GlobalData.getOrCreateConversationId(
                currentUser?.email ?? '',
                candidate.email,
                job.title,
              );

              final msgNote = noteText.isNotEmpty
                  ? '\n📝 Ghi chú: $noteText'
                  : '';

              final msg = {
                'text': '📅 Lịch phỏng vấn\n'
                    '💼 Vị trí: ${job.title}\n'
                    '🗓 Ngày: ${dateCtrl.text.trim()}\n'
                    '⏰ Giờ: ${timeCtrl.text.trim()}\n'
                    '📍 Địa điểm: ${locationCtrl.text.trim()}'
                    '$msgNote\n\n'
                    'Vui lòng xác nhận tham dự nhé! 🙏',
                'isMe': false,
                'sender': currentUser?.email ?? '',
                'senderName': currentUser?.companyName ??
                    currentUser?.fullName ??
                    '',
                'time': _currentTime(),
                'timestamp': DateTime.now().millisecondsSinceEpoch,
                'type': 'interview_invite',
              };

              await GlobalData.addMessage(convId, msg);

              // ✅ Đóng dialog trước, rồi hiện snackbar
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '✅ Đã gửi lịch phỏng vấn cho $displayName!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB7E35),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Gửi lịch',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGET HỖ TRỢ
// ─────────────────────────────────────────────────────────────────────────────

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
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827))),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
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
            width: 76,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF6B7280))),
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

class _DialogField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _DialogField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFFEB7E35)),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFEB7E35)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}