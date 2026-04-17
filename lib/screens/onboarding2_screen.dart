import 'package:flutter/material.dart';

class Onboarding2Screen extends StatelessWidget {
  const Onboarding2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center( // Thêm Center ở đây
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
              mainAxisSize: MainAxisSize.min, // Chỉ chiếm không gian cần thiết
              children: [
                Container(
                  width: 327,
                  height: 251,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.handshake_outlined,
                      size: 80,
                      color: Color(0xFFEB7E35),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Tuyển dụng uy tín\nkết nối chất lượng',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 80), // Khoảng cách đến button
                SizedBox(
                  width: 293,
                  height: 67,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/who-are-you'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B75DE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
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