import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class HoSoSVScreen extends StatelessWidget {
  const HoSoSVScreen({super.key});

  int _calculateCompletion(dynamic user) {
    if (user == null) return 0;
    int score = 0;
    // email luôn có (non-nullable)
    score += 20;
    if (user.fullName?.isNotEmpty == true) score += 15;
    if (user.phone?.isNotEmpty == true) score += 10;
    if (user.school?.isNotEmpty == true) score += 10;
    if (user.major?.isNotEmpty == true) score += 10;
    if (user.gpa != null && user.gpa! > 0) score += 10;
    if (user.skills?.isNotEmpty == true) score += 15;
    if (user.avatarFile != null) score += 10;
    return score > 100 ? 100 : score;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final completion = _calculateCompletion(user);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/student-home', (route) => false);
          },
        ),
        title: const Text('Hồ sơ của tôi',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFFEB7E35)),
            onPressed: () => Navigator.pushNamed(context, '/cai-dat'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xFFEEEEEE),
                    backgroundImage: user?.avatarFile != null
                        ? FileImage(user!.avatarFile!)
                        : null,
                    child: user?.avatarFile == null
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/chinh-sua-ho-so'),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                            color: Color(0xFFEB7E35), shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              user?.displayName ?? 'Chưa cập nhật tên',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user?.school?.isNotEmpty == true ? user!.school! : 'Chưa cập nhật trường',
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // Độ hoàn thiện hồ sơ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Độ hoàn thiện hồ sơ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      Text('$completion%',
                          style: const TextStyle(
                              color: Color(0xFFEB7E35),
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: completion / 100,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.grey[200],
                    color: const Color(0xFFEB7E35),
                  ),
                  if (completion < 100)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        completion < 50
                            ? 'Hãy cập nhật thêm thông tin để tìm việc tốt hơn!'
                            : 'Gần hoàn thiện rồi, thêm vài thông tin nữa nhé!',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Thông tin cá nhân
            _sectionHeader('Thông tin cá nhân', context, '/chinh-sua-ho-so'),
            _infoRow(Icons.phone, 'Số điện thoại', user?.displayPhone ?? 'Chưa cập nhật'),
            _infoRow(Icons.email_outlined, 'Email', user?.email ?? ''),

            const SizedBox(height: 8),

            // Học vấn
            _sectionHeader('Học vấn', context, '/chinh-sua-ho-so'),
            _infoRow(Icons.school_outlined, 'Trường',
                user?.school ?? 'Chưa cập nhật'),
            _infoRow(Icons.book_outlined, 'Chuyên ngành',
                user?.major ?? 'Chưa cập nhật'),
            _infoRow(
                Icons.grade_outlined,
                'GPA',
                user?.gpa != null
                    ? '${user!.gpa!.toStringAsFixed(1)} / 4.0'
                    : 'Chưa cập nhật'),

            const SizedBox(height: 8),

            // Kỹ năng
            _sectionHeader('Kỹ năng', context, '/chinh-sua-ho-so'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: (user?.skills?.isNotEmpty == true)
                  ? Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user!.skills!.map((s) => Chip(
                            label: Text(s,
                                style: const TextStyle(color: Colors.white)),
                            backgroundColor: const Color(0xFF4779BB),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          )).toList(),
                    )
                  : const Text('Chưa có kỹ năng nào',
                      style: TextStyle(color: Colors.grey)),
            ),

            const SizedBox(height: 24),

            // Nút hành động
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/cv-cua-toi'),
                      icon: const Icon(Icons.description_outlined,
                          color: Color(0xFF4779BB)),
                      label: const Text('Xem CV của tôi',
                          style: TextStyle(
                              color: Color(0xFF4779BB),
                              fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF4779BB)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/chinh-sua-ho-so'),
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text('Chỉnh sửa hồ sơ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEB7E35),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/viec-da-ung-tuyen'),
                      icon: const Icon(Icons.work_outline, color: Colors.white),
                      label: const Text('Việc đã ứng tuyển',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4779BB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, BuildContext context, String route) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, route),
            child: const Text('Chỉnh sửa',
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFEB7E35),
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const Spacer(),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}