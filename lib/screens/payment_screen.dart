import 'package:flutter/material.dart';

class PaymentConfirmScreen extends StatefulWidget {
  const PaymentConfirmScreen({super.key});

  @override
  State<PaymentConfirmScreen> createState() => _PaymentConfirmScreenState();
}

class _PaymentConfirmScreenState extends State<PaymentConfirmScreen> {
  bool _agreed = false;
  String _planName = '';
  String _planPrice = '';
  int _planPriceValue = 0;
  String _paymentMethod = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _planName = args['planName'] ?? '';
      _planPrice = args['planPrice'] ?? '';
      _planPriceValue = args['planPriceValue'] ?? 0;
      _paymentMethod = args['paymentMethod'] ?? 'momo';
    }
  }

  String get _paymentMethodLabel {
    switch (_paymentMethod) {
      case 'momo':    return 'MoMo';
      case 'zalopay': return 'ZaloPay';
      case 'bank':    return 'Thẻ ngân hàng';
      default:        return 'MoMo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Xác nhận thanh toán',
            style: TextStyle(
                color: Color(0xFF0056A3),
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text('Tóm tắt đơn hàng',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),

            // ── Chi tiết đơn ─────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gói: $_planName',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('Phương thức: $_paymentMethodLabel',
                      style: const TextStyle(
                          color: Color(0xFF64748B), fontSize: 14)),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng cộng:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(
                        _planPrice,
                        style: const TextStyle(
                            color: Color(0xFFFF4D00),
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Checkbox đồng ý ──────────────────────────────────────
            Row(
              children: [
                Checkbox(
                  value: _agreed,
                  activeColor: const Color(0xFFEB7E35),
                  onChanged: (v) => setState(() => _agreed = v ?? false),
                ),
                const Expanded(
                  child: Text('Tôi đồng ý với các điều khoản dịch vụ',
                      style: TextStyle(
                          color: Color(0xFF475569), fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Bảo mật ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Column(children: [
                    Icon(Icons.lock, color: Color(0xFF0056A3)),
                    SizedBox(height: 4),
                    Text('SSL', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text('SECURE', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                  ]),
                  Column(children: [
                    Icon(Icons.security, color: Color(0xFF0056A3)),
                    SizedBox(height: 4),
                    Text('MÃ HÓA', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text('256-bit', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                  ]),
                  Column(children: [
                    Icon(Icons.verified_user, color: Color(0xFF0056A3)),
                    SizedBox(height: 4),
                    Text('AN TOÀN', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text('100%', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                  ]),
                ],
              ),
            ),

            const Spacer(),

            // ── Nút thanh toán ───────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _agreed
                    ? () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/payment-success',
                          (r) => r.settings.name == '/student-home' ||
                              r.settings.name == '/employer-home',
                          arguments: {'planName': _planName},
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB7E35),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('THANH TOÁN NGAY',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}