import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/job_model.dart';
import '../models/user_model.dart';
import '../models/global_data.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  String _selectedCategory = 'Tất cả';
  bool _showChat = false;

  // ── Tìm kiếm & bộ lọc ───────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Map<String, dynamic>? _activeFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Lọc jobs theo tất cả tiêu chí ───────────────────────────
  List<Job> _getFilteredJobs() {
    var jobs = GlobalData.getAllJobs();

    // 1. Lọc theo danh mục chip
    if (_selectedCategory != 'Tất cả') {
      jobs = jobs.where((j) => j.category == _selectedCategory).toList();
    }

    // 2. Lọc theo từ khóa tìm kiếm
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      jobs = jobs.where((j) {
        return j.title.toLowerCase().contains(q) ||
            j.company.toLowerCase().contains(q) ||
            j.location.toLowerCase().contains(q) ||
            j.category.toLowerCase().contains(q);
      }).toList();
    }

    // 3. Lọc theo bộ lọc nâng cao
    if (_activeFilter != null) {
      final type = _activeFilter!['type'] as String?;
      final areas = (_activeFilter!['areas'] as List).cast<String>();
      final shifts = (_activeFilter!['shifts'] as List).cast<String>();

      jobs = jobs.where((j) {
        // Loại công việc
        if (type != null && type.isNotEmpty) {
          final jobShift = j.shift.toLowerCase();
          final filterType = type.toLowerCase();
          if (!jobShift.contains(filterType) &&
              !filterType.contains(jobShift)) {
            return false;
          }
        }
        // Khu vực
        if (areas.isNotEmpty) {
          final loc = j.location.toLowerCase();
          if (!areas.any((a) => loc.contains(a.toLowerCase()))) return false;
        }
        // Ca làm
        if (shifts.isNotEmpty) {
          final text =
              '${j.description} ${j.shift} ${j.category}'.toLowerCase();
          if (!shifts.any((s) => text.contains(s.toLowerCase()))) return false;
        }
        return true;
      }).toList();
    }

    return jobs;
  }

  Future<void> _openFilter() async {
    final result = await Navigator.pushNamed(context, '/job-filter');
    if (result != null && result is Map<String, dynamic>) {
      setState(() => _activeFilter = result);
    }
  }

  void _clearFilter() => setState(() => _activeFilter = null);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final String fullName = userProvider.currentUser?.fullName ?? 'Bạn';
    final String userName = fullName.split(' ').last;
    final currentUserEmail = userProvider.currentUser?.email ?? '';

    final filteredJobs = _getFilteredJobs();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 27, 26, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Xin chào, $userName!',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _showChat = !_showChat),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _showChat
                            ? const Color(0xFFEB7E35)
                            : const Color(0xFFF5F6F4),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        _showChat
                            ? Icons.work_outline
                            : Icons.chat_bubble_outline,
                        color: _showChat
                            ? Colors.white
                            : const Color(0xFFEB7E35),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Thanh tìm kiếm (chỉ hiện khi xem danh sách job) ─
            if (!_showChat) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F3),
                    border: Border.all(color: const Color(0xFF858585)),
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.search, size: 22, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) =>
                              setState(() => _searchQuery = v),
                          decoration: const InputDecoration(
                            hintText: 'Tìm kiếm công việc ...',
                            border: InputBorder.none,
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 15,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      // Nút lọc
                      GestureDetector(
                        onTap: _openFilter,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: _activeFilter != null
                                ? const Color(0xFF004E94)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.tune,
                            size: 22,
                            color: _activeFilter != null
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Tags bộ lọc đang áp dụng ──────────────────────
              if (_activeFilter != null) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 32,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterTag(
                          label: _activeFilter!['type'] as String,
                          color: const Color(0xFF004E94)),
                      ...(_activeFilter!['areas'] as List)
                          .cast<String>()
                          .map((a) => _FilterTag(label: a)),
                      ...(_activeFilter!['shifts'] as List)
                          .cast<String>()
                          .map((s) => _FilterTag(label: s)),
                      GestureDetector(
                        onTap: _clearFilter,
                        child: Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close,
                                  size: 12,
                                  color: Colors.red.shade400),
                              const SizedBox(width: 4),
                              Text(
                                'Xóa lọc',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.red.shade400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],

            const SizedBox(height: 12),

            // ── Body ────────────────────────────────────────────
            Expanded(
              child: _showChat
                  ? _buildChatList(context, currentUserEmail)
                  : _buildJobList(filteredJobs, context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ── Danh sách jobs ──────────────────────────────────────────────────────
  Widget _buildJobList(List<Job> jobs, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCategoryChips(context),
          const SizedBox(height: 12),

          // Số kết quả
          if (_searchQuery.isNotEmpty || _activeFilter != null)
            Padding(
              padding: const EdgeInsets.only(left: 26, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tìm thấy ${jobs.length} việc làm',
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontFamily: 'Inter'),
                ),
              ),
            ),

          if (jobs.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Icon(Icons.search_off,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  const Text(
                    'Không tìm thấy công việc nào',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  if (_activeFilter != null) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _clearFilter,
                      child: const Text('Xóa bộ lọc',
                          style: TextStyle(color: Color(0xFF004E94))),
                    ),
                  ],
                ],
              ),
            )
          else
            ...jobs.map((job) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildJobCard(
                      context, job, _getBgColor(job.category)),
                )),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Chat list ───────────────────────────────────────────────────────────
  Widget _buildChatList(BuildContext context, String currentUserEmail) {
    final conversations =
        GlobalData.getConversationsForUser(currentUserEmail);

    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline,
                size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('Chưa có tin nhắn nào',
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('Hãy ứng tuyển và chat với nhà tuyển dụng',
                style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conv = conversations[index];
        final otherUser = conv['participant1'] == currentUserEmail
            ? conv['participant2']
            : conv['participant1'];

        final otherUserObj = GlobalData.users.firstWhere(
          (u) => u.email == otherUser,
          orElse: () => AppUser(
            email: otherUser,
            password: '',
            role: UserRole.nhaTuyenDung,
            fullName: otherUser.split('@')[0],
          ),
        );

        final msgs = GlobalData.getMessages(conv['id']);
        final lastMsg = msgs.isNotEmpty
            ? msgs.last['text']
            : 'Bắt đầu trò chuyện';

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/chat-detail',
              arguments: {
                'conversationId': conv['id'],
                'jobTitle': conv['jobTitle'],
                'otherUserEmail': otherUser,
                'otherUserName': otherUserObj.displayName,
              },
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200, blurRadius: 5)
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFEB7E35),
                  child: Text(
                    otherUserObj.displayName[0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(otherUserObj.displayName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(lastMsg,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────
  Color _getBgColor(String category) {
    switch (category) {
      case 'Kinh doanh':
        return const Color(0xFFF7F7F5);
      case 'Giáo dục':
        return const Color(0xFFF7F3F6);
      case 'Công nghệ':
        return const Color(0xFFF0F7FF);
      case 'Marketing':
        return const Color(0xFFFFF5F0);
      default:
        return const Color(0xFFF5F4F2);
    }
  }

  Widget _buildCategoryChips(BuildContext context) {
    final categories = [
      'Tất cả',
      'Kinh doanh',
      'Công nghệ',
      'Marketing',
      'Giáo dục',
      'Khác'
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        children: categories
            .map((cat) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildChip(cat,
                      isSelected: _selectedCategory == cat),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Job job, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, '/job-detail', arguments: job),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(21)),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.work_outline,
                    size: 28, color: Color(0xFFEB7E35)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(job.salary,
                        style: const TextStyle(
                            color: Color(0xFFEB7E35),
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(job.location,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ),
              // Badge loại ca
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF004E94).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  job.shift,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF004E94),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 85,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F6F4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Trang chủ', !_showChat,
              () => setState(() => _showChat = false)),
          _buildNavItem(Icons.chat_bubble, 'Chat', _showChat,
              () => setState(() => _showChat = true)),
          _buildNavItem(Icons.assignment, 'Ứng tuyển', false,
              () => Navigator.pushNamed(context, '/viec-da-ung-tuyen')),
          _buildNavItem(Icons.person, 'Hồ sơ', false,
              () => Navigator.pushReplacementNamed(context, '/ho-so-sv')),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFEB7E35)
              : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color: isSelected
                  ? const Color(0xFFEB7E35)
                  : const Color(0xFFC2C2C2)),
        ),
        child: Text(label,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black)),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isActive
                    ? const Color(0xFFEB7E35)
                    : Colors.black45,
                size: 26),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: isActive
                        ? const Color(0xFFEB7E35)
                        : Colors.black45,
                    fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ── Filter tag widget ────────────────────────────────────────────────────────
class _FilterTag extends StatelessWidget {
  final String label;
  final Color? color;

  const _FilterTag({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFF6B7280);
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: c,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}