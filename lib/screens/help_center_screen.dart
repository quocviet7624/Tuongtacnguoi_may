import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  String _searchQuery = '';
  int _selectedCategory = 0;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.grid_view_rounded, 'label': 'Tất cả'},
    {'icon': Icons.person_outline, 'label': 'Tài khoản'},
    {'icon': Icons.work_outline, 'label': 'Việc làm'},
    {'icon': Icons.description_outlined, 'label': 'Hồ sơ'},
    {'icon': Icons.payment_outlined, 'label': 'Thanh toán'},
  ];

  final List<Map<String, dynamic>> _faqs = [
    {
      'category': 1,
      'question': 'Làm thế nào để đổi mật khẩu tài khoản?',
      'answer':
          'Vào Hồ sơ → Cài đặt → Đổi mật khẩu. Nhập mật khẩu hiện tại, sau đó nhập mật khẩu mới và xác nhận. Mật khẩu cần có ít nhất 8 ký tự.',
      'isExpanded': false,
    },
    {
      'category': 1,
      'question': 'Tôi quên mật khẩu, phải làm gì?',
      'answer':
          'Tại màn hình đăng nhập, nhấn "Quên mật khẩu". Nhập email đã đăng ký, chúng tôi sẽ gửi mã OTP để xác minh và đặt lại mật khẩu.',
      'isExpanded': false,
    },
    {
      'category': 2,
      'question': 'Làm thế nào để tìm việc gần tôi nhất?',
      'answer':
          'Bật tính năng "Việc làm gần đây" tại màn hình chính. Ứng dụng sẽ yêu cầu quyền truy cập vị trí để hiển thị các công việc trong bán kính bạn chọn trên bản đồ.',
      'isExpanded': false,
    },
    {
      'category': 2,
      'question': 'Tôi có thể lưu bao nhiêu việc làm yêu thích?',
      'answer':
          'Tài khoản miễn phí có thể lưu tối đa 20 việc làm. Nâng cấp lên gói Premium để lưu không giới hạn và nhận thông báo khi có việc phù hợp.',
      'isExpanded': false,
    },
    {
      'category': 3,
      'question': 'Làm thế nào để tải CV lên hệ thống?',
      'answer':
          'Vào Hồ sơ → CV của tôi → Tải CV lên. Hỗ trợ file PDF, DOCX dưới 5MB. Bạn có thể có nhiều CV khác nhau cho từng loại công việc.',
      'isExpanded': false,
    },
    {
      'category': 3,
      'question': 'Nhà tuyển dụng có thể xem hồ sơ của tôi không?',
      'answer':
          'Bạn có thể kiểm soát quyền riêng tư. Vào Cài đặt → Quyền riêng tư → Chế độ hiển thị hồ sơ để bật/tắt hoặc chỉ cho phép một số công ty xem.',
      'isExpanded': false,
    },
    {
      'category': 4,
      'question': 'Các phương thức thanh toán nào được hỗ trợ?',
      'answer':
          'ViecNow hỗ trợ: Thẻ ATM nội địa (Napas), Thẻ VISA/Mastercard, VNPay, MoMo, ZaloPay và chuyển khoản ngân hàng.',
      'isExpanded': false,
    },
    {
      'category': 4,
      'question': 'Chính sách hoàn tiền của ViecNow như thế nào?',
      'answer':
          'Trong 7 ngày kể từ ngày mua, bạn có thể yêu cầu hoàn tiền nếu chưa sử dụng bất kỳ tính năng Premium nào. Liên hệ hỗ trợ để được xử lý.',
      'isExpanded': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredFaqs {
    return _faqs.where((faq) {
      final matchCategory = _selectedCategory == 0 || faq['category'] == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          faq['question'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Trợ giúp & Hỗ trợ',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1F2937), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE5E7EB)),
        ),
      ),
      body: ListView(
        children: [
          // Header banner
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Xin chào! Chúng tôi có thể\ngiúp gì cho bạn?',
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                // Search
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Tìm câu hỏi thường gặp...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Quick contact options
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Liên hệ hỗ trợ',
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ContactCard(
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat ngay',
                      subtitle: 'Phản hồi trong 5 phút',
                      color: const Color(0xFFEB7E35),
                      onTap: () => Navigator.pushNamed(context, '/chat-list'),
                    ),
                    const SizedBox(width: 12),
                    _ContactCard(
                      icon: Icons.email_outlined,
                      label: 'Gửi email',
                      subtitle: 'support@viecnow.vn',
                      color: const Color(0xFF1976D2),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Category tabs
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: List.generate(_categories.length, (i) {
                  final isSelected = _selectedCategory == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = i),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFEB7E35) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _categories[i]['icon'] as IconData,
                            size: 14,
                            color: isSelected ? Colors.white : const Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _categories[i]['label'] as String,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF6B7280),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // FAQ accordion
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Câu hỏi thường gặp (${_filteredFaqs.length})',
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                if (_filteredFaqs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Không tìm thấy câu hỏi phù hợp',
                        style: TextStyle(color: Colors.grey[400], fontFamily: 'Inter'),
                      ),
                    ),
                  )
                else
                  ..._filteredFaqs.asMap().entries.map((entry) {
                    final idx = _faqs.indexOf(entry.value);
                    final faq = entry.value;
                    return _FaqItem(
                      question: faq['question'] as String,
                      answer: faq['answer'] as String,
                      isExpanded: faq['isExpanded'] as bool,
                      onToggle: () {
                        setState(() {
                          _faqs[idx]['isExpanded'] = !(_faqs[idx]['isExpanded'] as bool);
                        });
                      },
                    );
                  }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Still need help
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                const Icon(Icons.headset_mic_outlined, size: 40, color: Color(0xFFEB7E35)),
                const SizedBox(height: 10),
                const Text(
                  'Vẫn cần hỗ trợ thêm?',
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Đội ngũ hỗ trợ của chúng tôi sẵn sàng giúp đỡ\nbạn 24/7 qua chat hoặc email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/chat-list'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEB7E35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Liên hệ hỗ trợ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                        ),
                      ),
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
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 11,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _FaqItem({
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: TextStyle(
                      color: const Color(0xFF1F2937),
                      fontSize: 14,
                      fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w500,
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFFEB7E35),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 14),
            child: Text(
              answer,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 13,
                fontFamily: 'Inter',
                height: 1.6,
              ),
            ),
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }
}