import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/global_data.dart';
import '../models/user_model.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String _searchQuery = '';
  String _filter = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Vui lòng đăng nhập')),
      );
    }

    final conversations =
        GlobalData.getConversationsForUser(currentUser.email);

    var filteredConversations = conversations.where((c) {
      final otherUser = c['participant1'] == currentUser.email
          ? c['participant2']
          : c['participant1'];
      final userInfo = GlobalData.users.firstWhere(
        (u) => u.email == otherUser,
        orElse: () => _createPlaceholderUser(otherUser as String),
      );

      // ✅ Dùng displayName getter thay vì fullName trực tiếp
      final name = userInfo.displayName;
      final jobTitle = c['jobTitle'] ?? '';

      final matchesSearch = _searchQuery.isEmpty ||
          name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          jobTitle.toString().toLowerCase().contains(_searchQuery.toLowerCase());

      final hasUnread = (c['unread'] ?? 0) > 0;
      final matchesFilter = _filter == 'Tất cả' ||
          (_filter == 'Chưa đọc' && hasUnread) ||
          (_filter == 'Đã đọc' && !hasUnread);

      return matchesSearch && matchesFilter;
    }).toList();

    final displayConversations = filteredConversations.map((c) {
      final otherUserEmail = c['participant1'] == currentUser.email
          ? c['participant2']
          : c['participant1'];
      final userInfo = GlobalData.users.firstWhere(
        (u) => u.email == otherUserEmail,
        orElse: () => _createPlaceholderUser(otherUserEmail as String),
      );

      final msgs = GlobalData.getMessages(c['id']);
      final lastMsg = msgs.isNotEmpty ? msgs.last : null;

      // ✅ Dùng displayName getter, không còn lỗi String?
      String displayName;
      if (currentUser.role == UserRole.nhaTuyenDung) {
        displayName = userInfo.displayName;
      } else {
        displayName =
            userInfo.companyName ?? userInfo.fullName ?? 'Công ty';
      }

      return {
        'id': c['id'],
        'name': displayName,
        'avatar': _getAvatar(displayName),
        'avatarColor': _getAvatarColor(displayName),
        'lastMessage': lastMsg?['text'] ?? 'Chưa có tin nhắn',
        'time': lastMsg != null ? _formatTime(lastMsg['time']) : '',
        'unread': c['unread'] ?? 0,
        'isOnline': false,
        'jobTitle': c['jobTitle'] ?? '',
        'otherUserEmail': otherUserEmail,
        'participant1': c['participant1'],
        'participant2': c['participant2'],
      };
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tin nhắn',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color(0xFF1F2937), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                color: Color(0xFFEB7E35)),
            onPressed: () => _startNewConversation(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child:
              Container(height: 1, color: const Color(0xFFE5E7EB)),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm cuộc trò chuyện...',
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 15,
                  fontFamily: 'Inter',
                ),
                prefixIcon: const Icon(Icons.search,
                    color: Color(0xFF9CA3AF), size: 20),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Tất cả',
                  isSelected: _filter == 'Tất cả',
                  onTap: () => setState(() => _filter = 'Tất cả'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Chưa đọc',
                  isSelected: _filter == 'Chưa đọc',
                  onTap: () => setState(() => _filter = 'Chưa đọc'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Đã đọc',
                  isSelected: _filter == 'Đã đọc',
                  onTap: () => setState(() => _filter = 'Đã đọc'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: displayConversations.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    itemCount: displayConversations.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 0),
                    itemBuilder: (context, index) {
                      final conv = displayConversations[index];
                      return _ConversationTile(
                        conversation: conv,
                        onTap: () {
                          _markAsRead(conv['id'] as String);
                          Navigator.pushNamed(
                            context,
                            '/chat-detail',
                            arguments: conv,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline,
              size: 60, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Chưa có cuộc trò chuyện nào',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Tin nhắn sẽ xuất hiện khi có ứng tuyển hoặc phỏng vấn',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _markAsRead(String conversationId) {
    final conv = GlobalData.conversations.firstWhere(
      (c) => c['id'] == conversationId,
      orElse: () => {},
    );
    if (conv.isNotEmpty) conv['unread'] = 0;
  }

  void _startNewConversation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bắt đầu cuộc trò chuyện'),
        content: const Text(
            'Tính năng đang phát triển. Cuộc trò chuyện tự động tạo khi có ứng tuyển.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  AppUser _createPlaceholderUser(String email) {
    return AppUser(
      email: email,
      password: '',
      role: UserRole.sinhVien,
      fullName: email,
    );
  }

  String _getAvatar(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFF1976D2),
      const Color(0xFF00704A),
      const Color(0xFF00B14F),
      const Color(0xFFEB7E35),
      const Color(0xFFFF6D00),
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
    ];
    return colors[name.hashCode % colors.length];
  }

  String _formatTime(dynamic time) {
    if (time == null) return '';
    if (time is DateTime) {
      final now = DateTime.now();
      if (time.day == now.day &&
          time.month == now.month &&
          time.year == now.year) {
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      }
      return '${time.day}/${time.month}';
    }
    return time.toString();
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFEB7E35)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                isSelected ? Colors.white : const Color(0xFF6B7280),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Map<String, dynamic> conversation;
  final VoidCallback onTap;

  const _ConversationTile(
      {required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = (conversation['unread'] as int) > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor:
                      conversation['avatarColor'] as Color,
                  child: Text(
                    conversation['avatar'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                if (conversation['isOnline'] as bool)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.white, width: 2),
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
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation['name'] as String,
                        style: TextStyle(
                          color: const Color(0xFF1F2937),
                          fontSize: 15,
                          fontWeight: hasUnread
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        conversation['time'] as String,
                        style: TextStyle(
                          color: hasUnread
                              ? const Color(0xFFEB7E35)
                              : const Color(0xFF9CA3AF),
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    conversation['jobTitle'] as String,
                    style: const TextStyle(
                      color: Color(0xFFEB7E35),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          conversation['lastMessage'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: hasUnread
                                ? const Color(0xFF374151)
                                : const Color(0xFF9CA3AF),
                            fontSize: 13,
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.w400,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEB7E35),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${conversation['unread']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}