import 'package:flutter/material.dart';

class DiemThuongScreen extends StatelessWidget {
  const DiemThuongScreen({super.key});

  final List<Map<String, dynamic>> _history = const [
    {
      'title': 'Ứng tuyển thành công',
      'time': 'Hôm nay • 10:30',
      'points': '+50đ',
      'color': Color(0xFF43A047),
      'icon': Icons.check_circle_outline,
    },
    {
      'title': 'Đánh giá nhà tuyển dụng',
      'time': 'Hôm qua • 14:45',
      'points': '+20đ',
      'color': Color(0xFF43A047),
      'icon': Icons.star_outline,
    },
    {
      'title': 'Trao đổi quà',
      'time': 'Tuần trước • 09:15',
      'points': '-100đ',
      'color': Color(0xFFE53935),
      'icon': Icons.card_giftcard_outlined,
    },
    {
      'title': 'Hoàn thành hồ sơ',
      'time': '2 tuần trước • 16:00',
      'points': '+30đ',
      'color': Color(0xFF43A047),
      'icon': Icons.person_outline,
    },
    {
      'title': 'Đăng nhập hàng ngày',
      'time': '3 tuần trước • 08:00',
      'points': '+10đ',
      'color': Color(0xFF43A047),
      'icon': Icons.login,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // App bar với gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1565C0),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: const Text(
              'ViecNow',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1565C0), Color(0xFF1976D2), Color(0xFF2196F3)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tổng điểm của bạn',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '1.250 điểm',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              '1 điểm = 1 VND',
                              style: TextStyle(color: Colors.white60, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Cách kiếm điểm
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cách kiếm điểm',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF111111)),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildEarnCard('Ứng tuyển', '+50đ', Icons.work, const Color(0xFF1976D2)),
                            const SizedBox(width: 10),
                            _buildEarnCard('Đánh giá', '+20đ', Icons.star, const Color(0xFFFF8A00)),
                            const SizedBox(width: 10),
                            _buildEarnCard('Đăng nhập', '+10đ', Icons.login, const Color(0xFF43A047)),
                            const SizedBox(width: 10),
                            _buildEarnCard('Hoàn tất hồ sơ', '+30đ', Icons.person, const Color(0xFF9C27B0)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Đổi điểm
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Trao đổi điểm',
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '500 điểm → Miễn phí CV chuyên nghiệp',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _showRedeemDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1976D2),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('NHẬN NGAY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),

                // Lịch sử điểm
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Lịch sử điểm',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF111111)),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Xem tất cả', style: TextStyle(color: Color(0xFF1976D2), fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Danh sách lịch sử
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = _history[index];
                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: (item['color'] as Color).withOpacity(0.12),
                        child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: const TextStyle(
                                color: Color(0xFF222222),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['time'] as String,
                              style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        item['points'] as String,
                        style: TextStyle(
                          color: item['color'] as Color,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: _history.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildEarnCard(String label, String points, IconData icon, Color color) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF666666)), textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(points, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  void _showRedeemDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Icon(Icons.card_giftcard, size: 48, color: Color(0xFF1976D2)),
            const SizedBox(height: 12),
            const Text('Đổi 500 điểm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text('Nhận miễn phí CV chuyên nghiệp được thiết kế bởi đội ngũ ViecNow.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF666666))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã đổi thành công! Kiểm tra email của bạn.'), backgroundColor: Color(0xFF43A047)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Xác nhận đổi điểm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy', style: TextStyle(color: Color(0xFF666666))),
            ),
          ],
        ),
      ),
    );
  }
}