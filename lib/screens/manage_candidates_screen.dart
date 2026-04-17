import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/global_data.dart';
import '../models/user_model.dart';
import '../models/job_model.dart';

class ManageCandidatesScreen extends StatefulWidget {
  const ManageCandidatesScreen({super.key});

  @override
  State<ManageCandidatesScreen> createState() => _ManageCandidatesScreenState();
}

class _ManageCandidatesScreenState extends State<ManageCandidatesScreen> {
  String? _filterJobId; // null = tất cả jobs
  String _searchQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Nhận jobId từ arguments (từ ManageJobsTab > "Xem >")
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) {
      _filterJobId = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
    final myJobs = GlobalData.getJobsByEmployer(currentUser?.email ?? '');

    // Xây danh sách ứng viên thực từ GlobalData
    final List<Map<String, dynamic>> allCandidates = [];

    for (final job in myJobs) {
      if (_filterJobId != null && job.id != _filterJobId) continue;
      final applicantEmails = GlobalData.getJobApplicants(job.id);
      for (final email in applicantEmails) {
        final user = GlobalData.users.firstWhere(
          (u) => u.email == email,
          orElse: () => AppUser(
            email: email,
            password: '',
            role: UserRole.sinhVien,
            fullName: email,
          ),
        );
        allCandidates.add({
          'user': user,
          'job': job,
          'email': email,
        });
      }
    }

    // Lọc theo search
    final filtered = allCandidates.where((c) {
      final user = c['user'] as AppUser;
      final job = c['job'] as Job;
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return (user.fullName.toLowerCase().contains(q)) ||
          (user.email.toLowerCase().contains(q)) ||
          (job.title.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1F2937), size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          _filterJobId != null
              ? 'Ứng viên: ${myJobs.firstWhere((j) => j.id == _filterJobId, orElse: () => myJobs.first).title}'
              : 'Hồ sơ ứng viên',
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          // Filter chips theo job
          if (myJobs.isNotEmpty) ...[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _JobChip(
                      label: 'Tất cả',
                      isSelected: _filterJobId == null,
                      onTap: () => setState(() => _filterJobId = null),
                    ),
                    const SizedBox(width: 8),
                    ...myJobs.map((job) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _JobChip(
                            label: job.title,
                            count: GlobalData.getApplicantCount(job.id),
                            isSelected: _filterJobId == job.id,
                            onTap: () => setState(() => _filterJobId = job.id),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],

          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Tìm tên, email ứng viên...',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Summary
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filtered.length} ứng viên',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),

          // List
          Expanded(
            child: filtered.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final user = item['user'] as AppUser;
                      final job = item['job'] as Job;
                      return _CandidateCard(
                        user: user,
                        job: job,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/candidate-detail',
                            arguments: {
                              'user': user,
                              'job': job,
                            },
                          );
                        },
                        onChat: () => _openChat(context, user, job),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _openChat(BuildContext context, AppUser candidate, Job job) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            _filterJobId != null
                ? 'Chưa có ứng viên cho tin này'
                : 'Chưa có ứng viên nào',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            'Ứng viên sẽ xuất hiện khi sinh viên ứng tuyển',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Chip lọc theo job ──────────────────────────────────────────────────────
class _JobChip extends StatelessWidget {
  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;

  const _JobChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEB7E35) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (count != null && count! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white24 : const Color(0xFFEB7E35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Card ứng viên ──────────────────────────────────────────────────────────
class _CandidateCard extends StatelessWidget {
  final AppUser user;
  final Job job;
  final VoidCallback onTap;
  final VoidCallback onChat;

  const _CandidateCard({
    required this.user,
    required this.job,
    required this.onTap,
    required this.onChat,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
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
    final displayName = user.fullName.isNotEmpty ? user.fullName : user.email;
    final avatarColor = _getColor(displayName);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: avatarColor,
                  backgroundImage:
                      user.avatarFile != null ? FileImage(user.avatarFile!) : null,
                  child: user.avatarFile == null
                      ? Text(
                          _getInitials(displayName),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                ),
                // Nhắn tin nhanh
                GestureDetector(
                  onTap: onChat,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.chat_bubble_outline,
                        color: Color(0xFFEB7E35), size: 20),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 10),

            // Thông tin học vấn
            _InfoChip(
                icon: Icons.school_outlined,
                label: user.school ?? 'Chưa cập nhật trường'),
            const SizedBox(height: 6),
            _InfoChip(
                icon: Icons.work_outline, label: 'Ứng tuyển: ${job.title}'),

            if (user.skills != null && user.skills!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: user.skills!.take(4).map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBAE6FD)),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF0369A1)),
                    ),
                  );
                }).toList(),
              ),
            ],

            if (user.gpa != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Color(0xFFEAB308)),
                  const SizedBox(width: 4),
                  Text('GPA: ${user.gpa!.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF374151))),
                ],
              ),
            ],

            const SizedBox(height: 10),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onChat,
                    icon: const Icon(Icons.chat_bubble_outline, size: 16),
                    label: const Text('Nhắn tin'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEB7E35),
                      side: const BorderSide(color: Color(0xFFEB7E35)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('Xem hồ sơ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEB7E35),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}