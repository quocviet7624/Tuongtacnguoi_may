import 'package:flutter/material.dart';

class DatLaiMatKhauScreen extends StatefulWidget {
  const DatLaiMatKhauScreen({super.key});

  @override
  State<DatLaiMatKhauScreen> createState() => _DatLaiMatKhauScreenState();
}

class _DatLaiMatKhauScreenState extends State<DatLaiMatKhauScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _success = false;

  // Tính độ mạnh mật khẩu
  int _strength(String pass) {
    if (pass.length < 6) return 0;
    int score = 0;
    if (pass.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(pass)) score++;
    if (RegExp(r'[0-9]').hasMatch(pass)) score++;
    if (RegExp(r'[!@#\$%^&*]').hasMatch(pass)) score++;
    return score;
  }

  Color _strengthColor(int s) {
    if (s <= 1) return Colors.red;
    if (s == 2) return Colors.orange;
    return Colors.green;
  }

  String _strengthLabel(int s) {
    if (s <= 1) return 'Yếu';
    if (s == 2) return 'Trung bình';
    return 'Mạnh';
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = _strength(_passCtrl.text);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Center(
                child: Text('Đặt lại mật khẩu mới',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 40),
              const Text('Mật khẩu mới',
                  style: TextStyle(
                      fontSize: 14, color: Color(0xFF333333))),
              const SizedBox(height: 8),
              _passField(_passCtrl, _obscure1,
                  () => setState(() => _obscure1 = !_obscure1)),
              const SizedBox(height: 20),
              const Text('Xác nhận mật khẩu mới',
                  style: TextStyle(
                      fontSize: 14, color: Color(0xFF333333))),
              const SizedBox(height: 8),
              _passField(_confirmCtrl, _obscure2,
                  () => setState(() => _obscure2 = !_obscure2)),
              const SizedBox(height: 20),
              // Strength indicator
              const Text('Mức độ mật khẩu:',
                  style: TextStyle(
                      fontSize: 14, color: Color(0xFF333333))),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: s >= 1
                            ? _strengthColor(s)
                            : const Color(0xFFDDDDDD),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: s >= 2
                            ? _strengthColor(s)
                            : const Color(0xFFDDDDDD),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: s >= 3
                            ? _strengthColor(s)
                            : const Color(0xFFDDDDDD),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Yếu',
                      style: TextStyle(fontSize: 12, color: Color(0xFF333333))),
                  const Text('Trung bình',
                      style: TextStyle(fontSize: 12, color: Color(0xFF333333))),
                  const Text('Mạnh',
                      style: TextStyle(fontSize: 12, color: Color(0xFF333333))),
                ],
              ),
              if (_success)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text('Mật khẩu đã thay đổi thành công!',
                            style: TextStyle(
                                color: Colors.green, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_passCtrl.text.isEmpty) return;
                    if (_passCtrl.text != _confirmCtrl.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Mật khẩu không khớp')));
                      return;
                    }
                    setState(() => _success = true);
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4779BB),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: const Text('Lưu',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passField(TextEditingController ctrl, bool obscure,
      VoidCallback toggle) {
    return Container(
      height: 50,
      decoration: ShapeDecoration(
        color: const Color(0xFFF8F8F8),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: '••••••••',
          hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
          suffixIcon: IconButton(
            icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20, color: Colors.grey),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }
}
