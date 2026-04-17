// screens/employer_home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/global_data.dart';
import 'cai_dat_screen.dart';
import 'manage_candidates_screen.dart';

class SwitchTabNotification extends Notification {
  final int tabIndex;
  SwitchTabNotification(this.tabIndex);
}

class EmployerHomeScreen extends StatefulWidget {
  final int initialTab;
  const EmployerHomeScreen({super.key, this.initialTab = 0});

  @override
  State<EmployerHomeScreen> createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      EmployerDashboardTab(),        // Đã bỏ const
      ManageJobsTab(),               // Đã bỏ const
      ManageCandidatesScreen(),      // Đã bỏ const
      CaiDatScreen(isTab: true),     // Đã bỏ const
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: NotificationListener<SwitchTabNotification>(
        onNotification: (notification) {
          setState(() => _currentIndex = notification.tabIndex);
          return true;
        },
        child: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
      ),
      floatingActionButton: (_currentIndex == 0 || _currentIndex == 1)
          ? FloatingActionButton(
              onPressed: () async {
                // Chờ kết quả từ màn hình đăng tin
                final result = await Navigator.pushNamed(context, '/post-job');
                if (result == true && mounted) {
                  setState(() {}); // Force rebuild toàn bộ để cập nhật danh sách
                }
              },
              backgroundColor: const Color(0xFFEB7E35),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFEB7E35),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Tin đăng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Ứng viên',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1: DASHBOARD
// ─────────────────────────────────────────────────────────────────────────────
class EmployerDashboardTab extends StatelessWidget {
  const EmployerDashboardTab({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Chào buổi sáng';
    if (hour < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;

    // ── Tính động từ GlobalData ──────────────────────────────────────────────
    final myJobs = GlobalData.getJobsByEmployer(user?.email ?? '');
    final myJobsCount = myJobs.length;
    final totalApplicants = myJobs.fold<int>(
      0, (sum, job) => sum + GlobalData.getApplicantCount(job.id),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_getGreeting()},',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey)),
                        const SizedBox(height: 2),
                        Text(
                          user?.companyName ?? user?.fullName ?? 'Doanh nghiệp',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, '/company-profile-edit'),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFEB7E35),
                      child: Text(
                        (user?.companyName ?? user?.fullName ?? 'D')[0]
                            .toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Thông tin công ty ─────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFFEB7E35), Color(0xFFFF9A5C)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thông tin doanh nghiệp',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 8),
                    _InfoRow(
                        icon: Icons.business,
                        label: user?.businessType ?? 'Chưa cập nhật'),
                    _InfoRow(
                        icon: Icons.receipt_long,
                        label: 'MST: ${user?.taxCode ?? 'N/A'}'),
                    _InfoRow(
                        icon: Icons.location_on_outlined,
                        label: user?.address ?? 'Chưa cập nhật địa chỉ'),
                    _InfoRow(
                        icon: Icons.phone_outlined,
                        label: user?.phone ?? 'Chưa có SĐT'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Thống kê động ─────────────────────────────────────────────
              Row(
                children: [
                  _StatCard(
                    label: 'Tin đang đăng',
                    value: myJobsCount.toString(),
                    icon: Icons.work_outline,
                    color: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF1E40AF),
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'Tổng ứng viên',
                    value: totalApplicants.toString(),
                    icon: Icons.people_outline,
                    color: const Color(0xFFFFF7ED),
                    iconColor: const Color(0xFF9A3412),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Hành động nhanh ───────────────────────────────────────────
              const Text('Hành động nhanh',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: [
                  _QuickActionBtn(Icons.add_box_outlined, 'Đăng tin mới',
                      () => Navigator.pushNamed(context, '/post-job')),
                  _QuickActionBtn(
                      Icons.calendar_month_outlined,
                      'Lịch phỏng vấn',
                      () => Navigator.pushNamed(
                          context, '/interview-schedule')),
                  _QuickActionBtn(Icons.chat_outlined, 'Tin nhắn',
                      () => Navigator.pushNamed(context, '/chat-list')),
                  _QuickActionBtn(
                      Icons.business_outlined,
                      'Hồ sơ công ty',
                      () => Navigator.pushNamed(
                          context, '/company-profile-edit')),
                ],
              ),
              const SizedBox(height: 24),

              // ── Biểu đồ tuần ──────────────────────────────────────────────
              const Text('Hiệu quả tuần này',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const _WeeklyBarChart(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2: QUẢN LÝ TIN ĐĂNG
// ─────────────────────────────────────────────────────────────────────────────
class ManageJobsTab extends StatelessWidget {
  const ManageJobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final myJobs = GlobalData.getJobsByEmployer(user?.email ?? '');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Tin tuyển dụng',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: myJobs.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work_off_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Chưa có tin tuyển dụng nào',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Nhấn + để đăng tin mới',
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myJobs.length,
              itemBuilder: (context, index) {
                final job = myJobs[index];
                final applicantCount =
                    GlobalData.getApplicantCount(job.id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(job.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                          _StatusChip(job.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(job.postedDateFormatted,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      Text('Hạn: ${job.expiryDate}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.people_alt_outlined,
                                  size: 18, color: Colors.blue),
                              const SizedBox(width: 6),
                              Text('$applicantCount ứng viên',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/manage-candidates',
                                  arguments: job.id,
                                ),
                                child: const Text('Ứng viên >',
                                    style: TextStyle(
                                        color: Color(0xFFEB7E35))),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red, size: 20),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Xoá tin?'),
                                      content: Text(
                                          'Xoá tin "${job.title}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx),
                                          child: const Text('Huỷ'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            GlobalData.removeJob(job.id);
                                            Navigator.pop(ctx);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          child: const Text('Xoá',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGETS DÙNG CHUNG
// ─────────────────────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip(this.status);

  Color get _bg {
    switch (status) {
      case 'Đã đóng': return const Color(0xFFFEE2E2);
      case 'Hết hạn': return const Color(0xFFFEF9C3);
      default:        return const Color(0xFFDCFCE7);
    }
  }

  Color get _fg {
    switch (status) {
      case 'Đã đóng': return const Color(0xFF991B1B);
      case 'Hết hạn': return const Color(0xFF854D0E);
      default:        return const Color(0xFF166534);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: _bg, borderRadius: BorderRadius.circular(6)),
      child: Text(status,
          style: TextStyle(
              color: _fg, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label,
                style:
                    const TextStyle(color: Colors.white, fontSize: 13),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color, iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827))),
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: iconColor,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionBtn(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFEB7E35), size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  const _WeeklyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final values = [65, 80, 45, 90, 70];
    final days = ['T2', 'T3', 'T4', 'T5', 'T6'];
    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lượt xem tin tuyển dụng',
              style: TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(values.length, (i) {
                final barH = (values[i] / maxVal * 90).toDouble();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${values[i]}',
                        style: const TextStyle(
                            fontSize: 10, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Container(
                      width: 32,
                      height: barH,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEB7E35).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(days[i],
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}