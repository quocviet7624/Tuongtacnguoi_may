import 'package:flutter/material.dart';

class RegisterChoiceScreen extends StatelessWidget {
  const RegisterChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text('ViecNow',
                  style: TextStyle(
                      color: Color(0xFF1A3C6E),
                      fontSize: 20,
                      fontWeight: FontWeight.w400)),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity, height: 64,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register-sv-1'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4779BB),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text('Đăng ký Sinh Viên',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity, height: 64,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register-ntd'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEB7E35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text('Đăng ký Nhà Tuyển Dụng',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Đã có tài khoản? Đăng nhập',
                  style: TextStyle(color: Color(0xFF4779BB), fontSize: 16)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
