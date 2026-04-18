import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final planName = (args is Map) ? (args['planName'] ?? 'Premium') : 'Premium';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120, height: 120,
                  decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded,
                      color: Color(0xFF16A34A), size: 72),
                ),
                const SizedBox(height: 32),
                const Text('Thanh toán thành công!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Text(
                  'Gói $planName của bạn đã được kích hoạt.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFF6B7280), fontSize: 15),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/student-home', (r) => false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEB7E35),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Khám phá ngay',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}