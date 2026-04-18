import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/global_data.dart';
import '../models/user_model.dart';

class InterviewScheduleScreen extends StatefulWidget {
  const InterviewScheduleScreen({super.key});

  @override
  State<InterviewScheduleScreen> createState() =>
      _InterviewScheduleScreenState();
}

class _InterviewScheduleScreenState extends State<InterviewScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    final user = context.watch<UserProvider>().currentUser;
    final isEmployer = user?.role == UserRole.nhaTuyenDung;

    final myInterviews = isEmployer
        ? GlobalData.getInterviewsForEmployer(user?.email ?? '')
        : GlobalData.getInterviewsForStudent(user?.email ?? '');

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
          _InterviewListTab(
            interviews: myInterviews,
            isEmployer: isEmployer,
            onRefresh: () => setState(() {}),
          ),
          const _WorkLogTab(),
        ],
      ),
    );
  }
}

// ── Tab danh sách lịch phỏng vấn ───────────────────────────────────────────
class _InterviewListTab extends StatelessWidget {
  final List<Map<String, dynamic>> interviews;
  final bool isEmployer;
  final VoidCallback onRefresh;

  const _InterviewListTab({
    required this.interviews,
    required this.isEmployer,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (interviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              'Chưa có lịch phỏng vấn nào',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              isEmployer
                  ? 'Hẹn lịch phỏng vấn từ màn hình hồ sơ ứng viên'
                  : 'Lịch sẽ hiển thị khi nhà tuyển dụng gửi cho bạn',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: interviews.length,
      itemBuilder: (context, index) {
        final iv = interviews[index];
        return _InterviewCard(
          interview: iv,
          isEmployer: isEmployer,
          onStatusChanged: (newStatus) async {
            // ✅ Cập nhật status trực tiếp trong GlobalData.interviews
            final idx = GlobalData.interviews.indexWhere(
              (i) => i['id'] == iv['id'],
            );
            if (idx != -1) {
              GlobalData.interviews[idx]['status'] = newStatus;
              iv['status'] = newStatus; // cập nhật local ref để rebuild đúng
            }
            await GlobalData.saveInterviews();
            onRefresh();

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(newStatus == 'Đã xác nhận'
                      ? '✅ Đã xác nhận lịch phỏng vấn!'
                      : '❌ Đã từ chối lịch phỏng vấn'),
                  backgroundColor:
                      newStatus == 'Đã xác nhận' ? Colors.green : Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        );
      },
    );
  }
}

// ── Card từng lịch phỏng vấn ───────────────────────────────────────────────
class _InterviewCard extends StatelessWidget {
  final Map<String, dynamic> interview;
  final bool isEmployer;
  final ValueChanged<String> onStatusChanged;

  const _InterviewCard({
    required this.interview,
    required this.isEmployer,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final status = interview['status'] as String? ?? 'Chờ xác nhận';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header màu cam
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFEB7E35),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    interview['jobTitle'] as String? ?? '',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter'),
                  ),
                ),
                _StatusBadge(status),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Sinh viên thấy tên công ty; NTD thấy tên ứng viên
                _IVRow(
                  icon: Icons.person_outline,
                  text: isEmployer
                      ? 'Ứng viên: ${interview['candidateName'] ?? interview['candidateEmail'] ?? ''}'
                      : 'Công ty: ${interview['companyName'] ?? ''}',
                ),
                const SizedBox(height: 8),
                _IVRow(
                  icon: Icons.calendar_today,
                  text: 'Ngày: ${interview['date'] ?? ''}',
                ),
                const SizedBox(height: 6),
                _IVRow(
                  icon: Icons.access_time,
                  text: 'Giờ: ${interview['time'] ?? ''}',
                ),
                const SizedBox(height: 6),
                _IVRow(
                  icon: Icons.location_on_outlined,
                  text: 'Địa điểm: ${interview['location'] ?? ''}',
                ),
                if ((interview['note'] as String? ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _IVRow(
                    icon: Icons.note_outlined,
                    text: 'Ghi chú: ${interview['note']}',
                  ),
                ],

                // ✅ Nút cho sinh viên: chỉ hiện khi đang chờ
                if (!isEmployer && status == 'Chờ xác nhận') ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmAction(
                            context,
                            title: 'Từ chối lịch phỏng vấn?',
                            message:
                                'Bạn có chắc muốn từ chối lịch này không?',
                            confirmLabel: 'Từ chối',
                            confirmColor: Colors.red,
                            onConfirm: () => onStatusChanged('Đã từ chối'),
                          ),
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('Từ chối'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _confirmAction(
                            context,
                            title: 'Xác nhận tham dự?',
                            message:
                                'Bạn xác nhận sẽ tham gia buổi phỏng vấn này?',
                            confirmLabel: 'Xác nhận',
                            confirmColor: Colors.green,
                            onConfirm: () => onStatusChanged('Đã xác nhận'),
                          ),
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Xác nhận'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // ✅ Nhãn trạng thái cuối cho sinh viên (sau khi xử lý)
                if (!isEmployer && status != 'Chờ xác nhận') ...[
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      status == 'Đã xác nhận'
                          ? '✅ Bạn đã xác nhận tham dự'
                          : '❌ Bạn đã từ chối lịch này',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: status == 'Đã xác nhận'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],

                // ✅ Nút NTD: chat với ứng viên
                if (isEmployer) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final currentUser =
                            Provider.of<UserProvider>(context, listen: false)
                                .currentUser;
                        if (currentUser == null) return;
                        final convId =
                            GlobalData.getOrCreateConversationId(
                          currentUser.email,
                          interview['candidateEmail'] as String? ?? '',
                          interview['jobTitle'] as String? ?? '',
                        );
                        Navigator.pushNamed(
                          context,
                          '/chat-detail',
                          arguments: {
                            'id': convId,
                            'participant1': currentUser.email,
                            'participant2': interview['candidateEmail'],
                            'jobTitle': interview['jobTitle'],
                            'name': interview['candidateName'] ??
                                interview['candidateEmail'],
                            'avatar': ((interview['candidateName'] ??
                                        interview['candidateEmail'] ??
                                        'U') as String)
                                    .isNotEmpty
                                ? ((interview['candidateName'] ??
                                        interview['candidateEmail'] ??
                                        'U') as String)[0]
                                    .toUpperCase()
                                : 'U',
                            'avatarColor': const Color(0xFF1976D2),
                            'isOnline': false,
                          },
                        );
                      },
                      icon:
                          const Icon(Icons.chat_bubble_outline, size: 16),
                      label: const Text('Nhắn tin ứng viên'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEB7E35),
                        side:
                            const BorderSide(color: Color(0xFFEB7E35)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Dialog xác nhận hành động (tránh bấm nhầm)
  void _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text(message,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Quay lại',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(confirmLabel,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Status badge ────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  Color get _color {
    switch (status) {
      case 'Đã xác nhận':
        return Colors.green;
      case 'Đã từ chối':
        return Colors.red.shade300;
      default:
        return Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color),
      ),
      child: Text(
        status,
        style: TextStyle(
            fontSize: 11,
            color: _color,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Row thông tin ────────────────────────────────────────────────────────────
class _IVRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IVRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF374151),
                fontFamily: 'Inter'),
          ),
        ),
      ],
    );
  }
}

// ── Tab nhật ký làm việc ─────────────────────────────────────────────────────
class _WorkLogTab extends StatelessWidget {
  const _WorkLogTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Summary header
          Container(
            width: double.infinity,
            color: const Color(0xFF1A6FA8),
            padding: const EdgeInsets.all(24),
            child: const Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TỔNG GIỜ LÀM\nTHÁNG NÀY',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter'),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '48 GIỜ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter'),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ƯỚC TÍNH THU NHẬP',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter'),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1.200.000đ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter'),
                    ),
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
                const Text(
                  'THÁNG 10 • 2024',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'Inter'),
                ),
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
                        color: isWork
                            ? Colors.white
                            : const Color(0xFF111827),
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