import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  static const _code = 'VIECNOW123';

  static const _history = [
    {'name': 'Nguyễn Văn A', 'status': 'Đã xác nhận +100 điểm', 'done': true},
    {'name': 'Trần Thị B',   'status': 'Đang chờ',               'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Giới thiệu bạn bè -',
                style: TextStyle(color: Color(0xFF003566), fontSize: 30, fontWeight: FontWeight.w700)),
            const Text('Nhận điểm thưởng',
                style: TextStyle(color: Color(0xFF003566), fontSize: 30, fontWeight: FontWeight.w700)),
            const SizedBox(height: 32),
            const Text('Mã giới thiệu của bạn',
                style: TextStyle(fontSize: 18, color: Color(0xFF111827))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Text(_code,
                      style: const TextStyle(
                          color: Color(0xFFF97316),
                          fontSize: 22,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: _code));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã sao chép mã!')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEB7E35),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.copy, color: Colors.white, size: 16),
                    label: const Text('Sao chép', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Chia sẻ với bạn bè',
                style: TextStyle(fontSize: 18, color: Color(0xFF111827))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShare(const Color(0xFF0068FF), Icons.message, 'Zalo'),
                _buildShare(const Color(0xFF1877F2), Icons.facebook, 'Facebook'),
                _buildShare(const Color(0xFF374151), Icons.link, 'Sao chép link'),
              ],
            ),
            const SizedBox(height: 40),
            const Text('Lịch sử giới thiệu',
                style: TextStyle(color: Color(0xFF003566), fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ..._history.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 20, backgroundColor: Color(0xFFF3F4F6),
                      child: Icon(Icons.person, color: Colors.grey)),
                  const SizedBox(width: 12),
                  Text(item['name'] as String,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Text(item['status'] as String,
                      style: TextStyle(
                          fontSize: 14,
                          color: (item['done'] as bool)
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF6B7280))),
                ],
              ),
            )),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildShare(Color color, IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF111827))),
      ],
    );
  }
}