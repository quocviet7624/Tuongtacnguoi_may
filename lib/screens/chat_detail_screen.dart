import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/global_data.dart';
import '../models/user_model.dart'; // Thêm import này

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  late String _conversationId;
  late Map<String, dynamic> _conversation;
  late AppUser _currentUser;
  late AppUser _otherUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    _conversationId = args?['id'] ?? '';
    _conversation = args ?? {};
    
    final userProvider = Provider.of<UserProvider>(context);
    _currentUser = userProvider.currentUser!;
    
    // Xác định người còn lại
    final otherEmail = _conversation['participant1'] == _currentUser.email 
        ? _conversation['participant2'] 
        : _conversation['participant1'];
        
    // Tìm user hoặc tạo placeholder
    _otherUser = GlobalData.users.firstWhere(
      (u) => u.email == otherEmail,
      orElse: () => AppUser(
        email: otherEmail ?? '',
        password: '',
        role: UserRole.sinhVien,
        fullName: otherEmail ?? 'Unknown',
      ),
    );
  }

  List<Map<String, dynamic>> get _messages {
    return GlobalData.getMessages(_conversationId);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newMsg = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': text,
      'isMe': true,
      'senderEmail': _currentUser.email,
      'time': DateTime.now(),
      'type': 'text',
    };

    setState(() {
      GlobalData.addMessage(_conversationId, newMsg);
      _controller.clear();
      _isTyping = false;
    });

    // Cập nhật tin nhắn cuối trong conversation
    final conv = GlobalData.conversations.firstWhere(
      (c) => c['id'] == _conversationId,
      orElse: () => {},
    );
    if (conv.isNotEmpty) {
      conv['lastMessage'] = text;
      conv['lastMessageTime'] = DateTime.now();
      // Tăng unread cho người nhận
      if (conv['participant1'] == _currentUser.email) {
        conv['unread2'] = (conv['unread2'] ?? 0) + 1;
      } else {
        conv['unread1'] = (conv['unread1'] ?? 0) + 1;
      }
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Giả lập phản hồi tự động
    _simulateReply();
  }

  void _simulateReply() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      final replies = [
        'Cảm ơn bạn đã liên hệ!',
        'Chúng tôi sẽ xem xét và phản hồi sớm.',
        'Bạn có thể cho tôi biết thêm thông tin không?',
        'Rất vui được làm việc với bạn!',
      ];
      
      final reply = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': replies[DateTime.now().millisecond % replies.length],
        'isMe': false,
        'senderEmail': _otherUser.email,
        'time': DateTime.now(),
        'type': 'text',
      };

      setState(() {
        GlobalData.addMessage(_conversationId, reply);
      });

      final conv = GlobalData.conversations.firstWhere(
        (c) => c['id'] == _conversationId,
        orElse: () => {},
      );
      if (conv.isNotEmpty) {
        conv['lastMessage'] = reply['text'];
        conv['lastMessageTime'] = DateTime.now();
      }
    });
  }

  String _formatMessageTime(dynamic time) {
    if (time is DateTime) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return time?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // Xác định tên hiển thị
    String displayName;
    String avatar;
    Color avatarColor;
    
    if (_currentUser.role == UserRole.nhaTuyenDung) {
      // NTD đang chat với sinh viên
      displayName = _otherUser.fullName.isNotEmpty ? _otherUser.fullName : 'Ứng viên';
      avatar = _getAvatar(displayName);
      avatarColor = _getAvatarColor(displayName);
    } else {
      // Sinh viên đang chat với NTD
      displayName = _otherUser.companyName ?? _otherUser.fullName ?? 'Công ty';
      avatar = _getAvatar(displayName);
      avatarColor = _getAvatarColor(displayName);
    }

    final isOnline = false;
    final jobTitle = _conversation['jobTitle'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1F2937), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: avatarColor,
                  child: Text(
                    avatar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  isOnline ? 'Đang hoạt động' : jobTitle,
                  style: TextStyle(
                    color: isOnline ? const Color(0xFF22C55E) : const Color(0xFF9CA3AF),
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: Color(0xFFEB7E35)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF6B7280)),
            onPressed: () => _showOptions(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE5E7EB)),
        ),
      ),
      body: Column(
        children: [
          // Job info card
          if (jobTitle.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEB7E35).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.work_outline, color: Color(0xFFEB7E35)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Vị trí: $jobTitle',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Messages
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMe = msg['senderEmail'] == _currentUser.email;

                      return Column(
                        children: [
                          if (index == 0 || _shouldShowDate(index))
                            _DateSeparator(date: msg['time']),
                          
                          if (msg['type'] == 'interview_card')
                            _InterviewCard(
                              data: msg['cardData'], 
                              time: _formatMessageTime(msg['time']),
                            )
                          else
                            _MessageBubble(
                              text: msg['text'] as String,
                              isMe: isMe,
                              time: _formatMessageTime(msg['time']),
                              avatar: isMe ? _getAvatar(_currentUser.fullName) : avatar,
                              avatarColor: isMe ? const Color(0xFF4B75DE) : avatarColor,
                            ),
                          const SizedBox(height: 4),
                        ],
                      );
                    },
                  ),
          ),

          // Input area
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Color(0xFF9CA3AF)),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _controller,
                        onChanged: (v) => setState(() => _isTyping = v.isNotEmpty),
                        decoration: const InputDecoration(
                          hintText: 'Nhập tin nhắn...',
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _isTyping ? const Color(0xFFEB7E35) : const Color(0xFFE5E7EB),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: _isTyping ? Colors.white : const Color(0xFF9CA3AF),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
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
          Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Chưa có tin nhắn nào',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy gửi tin nhắn đầu tiên',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  bool _shouldShowDate(int index) {
    if (index == 0) return true;
    final prev = _messages[index - 1]['time'] as DateTime?;
    final curr = _messages[index]['time'] as DateTime?;
    if (prev == null || curr == null) return false;
    return prev.day != curr.day || prev.month != curr.month || prev.year != curr.year;
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

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OptionItem(
              icon: Icons.info_outline, 
              label: 'Xem thông tin ${_currentUser.role == UserRole.nhaTuyenDung ? 'ứng viên' : 'công ty'}', 
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context, 
                  _currentUser.role == UserRole.nhaTuyenDung ? '/ho-so-uv' : '/company-profile',
                );
              },
            ),
            _OptionItem(icon: Icons.block, label: 'Chặn', onTap: () => Navigator.pop(context)),
            _OptionItem(
              icon: Icons.report_outlined, 
              label: 'Báo cáo', 
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/report-job');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DateSeparator extends StatelessWidget {
  final dynamic date;

  const _DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    String text;
    if (date is DateTime) {
      final now = DateTime.now();
      if (date.day == now.day && date.month == now.month && date.year == now.year) {
        text = 'Hôm nay';
      } else if (date.day == now.day - 1 && date.month == now.month && date.year == now.year) {
        text = 'Hôm qua';
      } else {
        text = '${date.day}/${date.month}/${date.year}';
      }
    } else {
      text = 'Hôm nay';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 12,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final String avatar;
  final Color avatarColor;

  const _MessageBubble({
    required this.text,
    required this.isMe,
    required this.time,
    required this.avatar,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe) ...[
          CircleAvatar(
            radius: 14,
            backgroundColor: avatarColor,
            child: Text(avatar, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFFEB7E35) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isMe ? 18 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isMe ? Colors.white : const Color(0xFF1F2937),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11, fontFamily: 'Inter'),
              ),
            ],
          ),
        ),
        if (isMe) const SizedBox(width: 4),
      ],
    );
  }
}

class _InterviewCard extends StatelessWidget {
  final Map<String, dynamic>? data;
  final String time;

  const _InterviewCard({this.data, required this.time});

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox.shrink();
    
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 34),
        child: Container(
          width: 280,
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEB7E35).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFEB7E35),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.calendar_today, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Lịch phỏng vấn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _CardRow(icon: Icons.access_time, label: '${data!['date']} • ${data!['time']}'),
                    const SizedBox(height: 8),
                    _CardRow(icon: Icons.location_on_outlined, label: data!['location'] ?? 'Chưa cập nhật'),
                    const SizedBox(height: 8),
                    _CardRow(icon: Icons.person_outline, label: data!['interviewer'] ?? 'Chưa cập nhật'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/interview-schedule'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEB7E35),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'Xác nhận',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Đổi lịch',
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

class _CardRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CardRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: const Color(0xFFEB7E35)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 13,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF374151)),
      title: Text(
        label,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 15),
      ),
      onTap: onTap,
    );
  }
}