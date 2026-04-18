import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/global_data.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  late String conversationId;
  late String otherUserEmail;
  late String otherUserName;
  late String jobTitle;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final args = ModalRoute.of(context)!.settings.arguments as Map;
  
  // chat_list truyền 'id', không phải 'conversationId'
  conversationId = args['id'] ?? args['conversationId'] ?? '';
  otherUserEmail = args['otherUserEmail'] ?? '';
  
  // chat_list truyền 'name', không phải 'otherUserName'  
  otherUserName = args['name'] ?? args['otherUserName'] ?? 'Người dùng';
  jobTitle = args['jobTitle'] ?? 'Tin nhắn';
}
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final currentUser = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (currentUser == null) return;

    final now = DateTime.now();
    final message = {
      'text': text,
      'sender': currentUser.email,
      'senderName': currentUser.displayName,
      'time': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      'timestamp': now.millisecondsSinceEpoch,
    };

    GlobalData.addMessage(conversationId, message);
    _messageController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).currentUser;
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('Vui lòng đăng nhập')));
    }

    final List<Map<String, dynamic>> messages = GlobalData.getMessages(conversationId);
    
    final sortedMessages = List.from(messages)
      ..sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              otherUserName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              jobTitle,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFEB7E35),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: sortedMessages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Chưa có tin nhắn nào',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hãy gửi tin nhắn để bắt đầu trò chuyện',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    reverse: true,
                    itemCount: sortedMessages.length,
                    itemBuilder: (context, index) {
                      final msg = sortedMessages[sortedMessages.length - 1 - index];
                      final isMe = msg['sender'] == currentUser.email;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? const Color(0xFFEB7E35) : Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                msg['text'] ?? '',
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                msg['time'] ?? '',
                                style: TextStyle(
                                  color: isMe ? Colors.white70 : Colors.black54,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 5),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFFEB7E35),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}