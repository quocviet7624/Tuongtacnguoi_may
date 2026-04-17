import 'package:flutter/material.dart';

class WhoAreYouScreen extends StatelessWidget {
  const WhoAreYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text('Bạn là ai?',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700)),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/login'), // ← vào login
                      child: Container(
                        height: 234,
                        decoration: BoxDecoration(
                            color: const Color(0xFF8FC3E7),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.school_outlined,
                                size: 72, color: Colors.white),
                            SizedBox(height: 16),
                            Text('Tôi là\nsinh viên',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/login'), // ← vào login
                      child: Container(
                        height: 234,
                        decoration: BoxDecoration(
                            color: const Color(0xFFEB7E35),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.business_outlined,
                                size: 72, color: Colors.white),
                            SizedBox(height: 16),
                            Text('Tôi là nhà\ntuyển dụng',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Đã có tài khoản? Đăng nhập',
                  style: TextStyle(
                      color: Color(0xFF4779BB),
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}