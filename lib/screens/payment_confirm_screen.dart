import 'package:flutter/material.dart';

class PaymentConfirmScreen extends StatefulWidget {
  const PaymentConfirmScreen({super.key});

  @override
  State<PaymentConfirmScreen> createState() => _PaymentConfirmScreenState();
}

class _PaymentConfirmScreenState extends State<PaymentConfirmScreen> {
  bool _agreed = false;

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
        title: const Text('XÁC NHẬN THANH TOÁN',
            style: TextStyle(color: Color(0xFF0056A3), fontSize: 20, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text('Tóm tắt đơn hàng',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
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
                children: const [
                  Text('Đơn hàng #DH00123',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 16)),
                  SizedBox(height: 12),
                  Text('Sản phẩm: Gói Sinh Viên Pro',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SizedBox(height: 8),
                  Text('Số lượng: 1 | Giá: 29.000đ',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 16)),
                  Divider(height: 32),
                  Text('Tổng cộng: 29.000đ',
                      style: TextStyle(
                          color: Color(0xFFFF4D00),
                          fontSize: 26,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Checkbox(
                  value: _agreed,
                  activeColor: const Color(0xFFEB7E35),
                  onChanged: (v) => setState(() => _agreed = v ?? false),
                ),
                const Expanded(
                  child: Text('Tôi đồng ý với các điều khoản dịch vụ',
                      style: TextStyle(color: Color(0xFF475569), fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
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
                    Text('SSL', style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('SECURE', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  ]),
                  Column(children: [
                    Icon(Icons.security, color: Color(0xFF0056A3)),
                    SizedBox(height: 4),
                    Text('MÃ HÓA', style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('256-bit', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  ]),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _agreed
                    ? () => Navigator.pushNamed(context, '/payment-success')
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB7E35),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('THANH TOÁN NGAY',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}