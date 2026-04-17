import 'package:flutter/material.dart';

class GoiPremiumScreen extends StatefulWidget {
  const GoiPremiumScreen({super.key});

  @override
  State<GoiPremiumScreen> createState() => _GoiPremiumScreenState();
}

class _GoiPremiumScreenState extends State<GoiPremiumScreen> {
  int _selectedPlan = 1; // 0=Miễn phí, 1=Sinh Viên Pro, 2=VIP

  final List<Map<String, dynamic>> _plans = const [
    {
      'name': 'Miễn phí',
      'price': '0đ/tháng',
      'priceValue': 0,
      'badge': null,
      'features': [
        '5 ứng tuyển/tháng',
        'Tìm kiếm cơ bản',
        'Hồ sơ cơ bản',
        'Thông báo việc làm',
      ],
      'notIncluded': [
        'CV nổi bật',
        'Ưu tiên hiển thị',
        'Badge xác thực',
        'Hỗ trợ 24/7',
      ],
      'color': Color(0xFF757575),
      'buttonLabel': 'SỬ DỤNG MIỄN PHÍ',
      'buttonColor': Color(0xFF757575),
    },
    {
      'name': 'Sinh Viên Pro',
      'price': '29.000đ/tháng',
      'priceValue': 29000,
      'badge': '★ Phổ biến nhất',
      'features': [
        'Không giới hạn ứng tuyển',
        'CV nổi bật',
        'Tìm kiếm nâng cao',
        'Hồ sơ đầy đủ',
        'Thông báo ngay lập tức',
        'Hỗ trợ ưu tiên',
      ],
      'notIncluded': [
        'Ưu tiên hiển thị hàng đầu',
        'Badge xác thực VIP',
      ],
      'color': Color(0xFF1976D2),
      'buttonLabel': 'CHỌN GÓI',
      'buttonColor': Color(0xFF1976D2),
    },
    {
      'name': 'VIP',
      'price': '59.000đ/tháng',
      'priceValue': 59000,
      'badge': '👑 Cao cấp',
      'features': [
        'Không giới hạn ứng tuyển',
        'CV nổi bật hàng đầu',
        'Ưu tiên hiển thị',
        'Badge xác thực VIP',
        'Hỗ trợ 24/7',
        'Tư vấn nghề nghiệp',
        'Phân tích hồ sơ AI',
      ],
      'notIncluded': [],
      'color': Color(0xFFE65100),
      'buttonLabel': 'CHỌN GÓI',
      'buttonColor': Color(0xFFE65100),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: const Text(
              'Gói Premium',
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    children: [
                      const Text(
                        'ViecNow',
                        style: TextStyle(
                          color: Color(0xFF0056A3),
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Gói Premium (Sinh Viên)',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Nâng cấp tài khoản để tăng cơ hội tìm việc làm phù hợp',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF666666), fontSize: 14),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Plan cards
                ...List.generate(_plans.length, (i) => _buildPlanCard(context, i)),

                // Comparison table
                _buildComparisonSection(),

                // FAQ
                _buildFaqSection(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, int index) {
    final plan = _plans[index];
    final isSelected = _selectedPlan == index;
    final color = plan['color'] as Color;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            // Badge
            if (plan['badge'] != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Text(
                  plan['badge'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plan['name'] as String,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color),
                      ),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          child: const Icon(Icons.check, color: Colors.white, size: 16),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plan['price'] as String,
                    style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),

                  // Features
                  ...(plan['features'] as List<String>).map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: color, size: 18),
                        const SizedBox(width: 8),
                        Text(f, style: const TextStyle(fontSize: 14, color: Color(0xFF222222))),
                      ],
                    ),
                  )),

                  // Not included
                  ...(plan['notIncluded'] as List<String>).map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.cancel_outlined, color: Color(0xFFCCCCCC), size: 18),
                        const SizedBox(width: 8),
                        Text(f, style: const TextStyle(fontSize: 14, color: Color(0xFFAAAAAA))),
                      ],
                    ),
                  )),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handleSelectPlan(context, index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? color : const Color(0xFFF5F5F5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text(
                        plan['buttonLabel'] as String,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF666666),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('So sánh các gói', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(8)),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFFF8F9FA)),
                children: ['Tính năng', 'Miễn phí', 'Pro', 'VIP']
                    .map((h) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(h, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                        ))
                    .toList(),
              ),
              _buildTableRow('Ứng tuyển/tháng', '5', '∞', '∞'),
              _buildTableRow('CV nổi bật', '✗', '✓', '✓'),
              _buildTableRow('Ưu tiên hiển thị', '✗', '✗', '✓'),
              _buildTableRow('Badge VIP', '✗', '✗', '✓'),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String feature, String free, String pro, String vip) {
    return TableRow(children: [
      Padding(padding: const EdgeInsets.all(8), child: Text(feature, style: const TextStyle(fontSize: 12))),
      Padding(padding: const EdgeInsets.all(8), child: Text(free, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: free == '✗' ? Colors.red : Colors.green))),
      Padding(padding: const EdgeInsets.all(8), child: Text(pro, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: pro == '✗' ? Colors.red : const Color(0xFF1976D2)))),
      Padding(padding: const EdgeInsets.all(8), child: Text(vip, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: vip == '✗' ? Colors.red : const Color(0xFFE65100)))),
    ]);
  }

  Widget _buildFaqSection() {
    final faqs = [
      {'q': 'Có thể hủy gói bất cứ lúc nào không?', 'a': 'Có, bạn có thể hủy gói Premium bất kỳ lúc nào trong phần Cài đặt.'},
      {'q': 'Phương thức thanh toán nào được hỗ trợ?', 'a': 'ViecNow hỗ trợ MoMo, ZaloPay, thẻ ngân hàng nội địa và quốc tế.'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Câu hỏi thường gặp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          ...faqs.map((faq) => ExpansionTile(
            title: Text(faq['q']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(faq['a']!, style: const TextStyle(fontSize: 13, color: Color(0xFF666666))),
              ),
            ],
          )),
        ],
      ),
    );
  }

  void _handleSelectPlan(BuildContext context, int index) {
    final plan = _plans[index];
    if (plan['priceValue'] == 0) {
      Navigator.pop(context);
      return;
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('Xác nhận đăng ký ${plan['name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Giá: ${plan['price']}', style: const TextStyle(fontSize: 16, color: Color(0xFF1976D2))),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đăng ký ${plan['name']} thành công!'), backgroundColor: const Color(0xFF43A047)),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: plan['color'] as Color),
                child: const Text('Thanh toán', style: TextStyle(color: Colors.white)),
              )),
            ]),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}