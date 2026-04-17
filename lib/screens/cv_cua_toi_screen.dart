import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class CvCuaToiScreen extends StatelessWidget {
  const CvCuaToiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('CV của tôi',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header CV ──────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4779BB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white24,
                          backgroundImage: user?.avatarFile != null
                              ? FileImage(user!.avatarFile!)
                              : null,
                          child: user?.avatarFile == null
                              ? const Icon(Icons.person,
                                  size: 40, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.fullName.isNotEmpty == true
                                    ? user!.fullName
                                    : 'Chưa cập nhật',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.major ?? 'Chưa cập nhật chuyên ngành',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? '',
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Thông tin liên hệ ──────────────────────────────────
                  _cvSection('Thông tin liên hệ', [
                    _cvRow(Icons.phone, user?.phone.isNotEmpty == true
                        ? user!.phone
                        : 'Chưa cập nhật'),
                    _cvRow(Icons.email_outlined, user?.email ?? ''),
                  ]),

                  // ── Học vấn ────────────────────────────────────────────
                  _cvSection('Học vấn', [
                    if (user?.school != null && user!.school!.isNotEmpty)
                      _cvRow(Icons.school_outlined, user.school!),
                    if (user?.major != null && user!.major!.isNotEmpty)
                      _cvRow(Icons.book_outlined, user.major!),
                    if (user?.gpa != null)
                      _cvRow(Icons.grade_outlined,
                          'GPA: ${user!.gpa!.toStringAsFixed(1)} / 4.0'),
                  ]),

                  // ── Kỹ năng ───────────────────────────────────────────
                  _cvSectionTitle('Kỹ năng'),
                  const SizedBox(height: 8),
                  user?.skills?.isNotEmpty == true
                      ? Wrap(
                          spacing: 8, runSpacing: 8,
                          children: user!.skills!.map((s) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4779BB),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(s,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              )).toList(),
                        )
                      : const Text('Chưa cập nhật kỹ năng',
                          style: TextStyle(color: Colors.grey)),

                  const SizedBox(height: 24),

                  // ── Mức lương mong muốn ────────────────────────────────
                  if (user?.salaryMin != null || user?.salaryMax != null)
                    _cvSection('Mức lương mong muốn', [
                      _cvRow(Icons.monetization_on_outlined,
                          '${user?.salaryMin?.toStringAsFixed(0) ?? '?'} - ${user?.salaryMax?.toStringAsFixed(0) ?? '?'} triệu/tháng'),
                    ]),
                ],
              ),
            ),
          ),

          // ── Bottom buttons ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/chinh-sua-ho-so'),
                    icon: const Icon(Icons.edit,
                        color: Color(0xFFEB7E35), size: 18),
                    label: const Text('Chỉnh sửa',
                        style: TextStyle(color: Color(0xFFEB7E35))),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFEB7E35)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Tính năng xuất PDF sắp ra mắt!')));
                    },
                    icon: const Icon(Icons.download, color: Colors.white, size: 18),
                    label: const Text('Xuất PDF',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4779BB),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cvSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      child: Text(title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEB7E35))),
    );
  }

  Widget _cvSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cvSectionTitle(title),
        const SizedBox(height: 4),
        ...children,
      ],
    );
  }

  Widget _cvRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}