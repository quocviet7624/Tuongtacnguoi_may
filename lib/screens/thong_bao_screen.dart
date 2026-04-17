import 'package:flutter/material.dart';

class ThongBaoScreen extends StatefulWidget {
  const ThongBaoScreen({super.key});

  @override
  State<ThongBaoScreen> createState() => _ThongBaoScreenState();
}

class _ThongBaoScreenState extends State<ThongBaoScreen> {
  int _selectedTab = 0; // 0=Tất cả, 1=Việc làm, 2=Hệ thống

  final List<Map<String, dynamic>> _allNotifications = [
    {
      'title': 'Đơn ứng tuyển của bạn được xem',
      'subtitle': 'Công ty SmartDev • 10 phút trước',
      'type': 'job',
      'icon': Icons.visibility_outlined,
      'color': Color(0xFFEB7E35),
      'isRead': false,
    },
    {
      'title': 'Lịch phỏng vấn lúc 9:00 sáng mai',
      'subtitle': 'Công ty Alpha • 1 giờ trước',
      'type': 'job',
      'icon': Icons.calendar_today_outlined,
      'color': Color(0xFF1976D2),
      'isRead': false,
    },
    {
      'title': 'Bạn có 2 việc làm mới phù hợp',
      'subtitle': 'Việc làm • 2 ngày trước',
      'type': 'job',
      'icon': Icons.work_outline,
      'color': Color(0xFF43A047),
      'isRead': true,
    },
    {
      'title': 'Chào mừng bạn tham gia ViecNow',
      'subtitle': 'Hệ thống • 1 ngày trước',
      'type': 'system',
      'icon': Icons.celebration_outlined,
      'color': Color(0xFFEB7E35),
      'isRead': true,
    },
    {
      'title': 'Cập nhật điều khoản dịch vụ',
      'subtitle': 'Hệ thống • 3 ngày trước',
      'type': 'system',
      'icon': Icons.info_outline,
      'color': Color(0xFF757575),
      'isRead': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 0) return _allNotifications;
    if (_selectedTab == 1) return _allNotifications.where((n) => n['type'] == 'job').toList();
    return _allNotifications.where((n) => n['type'] == 'system').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _allNotifications) {
                  n['isRead'] = true;
                }
              });
            },
            child: const Text('Đọc tất cả', style: TextStyle(color: Color(0xFFEB7E35), fontSize: 13)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                _buildTab('Tất cả', 0),
                _buildTab('Việc làm', 1),
                _buildTab('Hệ thống', 2),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Notification list
          Expanded(
            child: _filteredNotifications.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none, size: 64, color: Color(0xFFDDDDDD)),
                        SizedBox(height: 12),
                        Text('Không có thông báo', style: TextStyle(color: Color(0xFF999999))),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredNotifications.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, indent: 72, color: Color(0xFFF0F0F0)),
                    itemBuilder: (context, index) {
                      final notif = _filteredNotifications[index];
                      return _buildNotificationItem(notif, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEB7E35) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notif, int index) {
    final isRead = notif['isRead'] as bool;
    return Dismissible(
      key: Key('notif_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        setState(() => _allNotifications.remove(notif));
      },
      child: InkWell(
        onTap: () {
          setState(() => notif['isRead'] = true);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          color: isRead ? Colors.white : const Color(0xFFFFF8F4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: (notif['color'] as Color).withOpacity(0.12),
                    child: Icon(notif['icon'] as IconData, color: notif['color'] as Color, size: 22),
                  ),
                  if (!isRead)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEB7E35),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif['title'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif['subtitle'] as String,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}