import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/global_data.dart';
import '../services/storage_service.dart';

class DoiMatKhauScreen extends StatefulWidget {
  const DoiMatKhauScreen({super.key});

  @override
  State<DoiMatKhauScreen> createState() => _DoiMatKhauScreenState();
}

class _DoiMatKhauScreenState extends State<DoiMatKhauScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confirmPwController = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPwController.dispose();
    _newPwController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser == null) {
      _showSnack('Bạn chưa đăng nhập', isError: true);
      return;
    }

    // ── Kiểm tra mật khẩu cũ có đúng không ──────────────────────
    if (_oldPwController.text.trim() != currentUser.password) {
      _showSnack('Mật khẩu cũ không chính xác', isError: true);
      return;
    }

    // ── Không cho đặt trùng mật khẩu cũ ─────────────────────────
    if (_newPwController.text.trim() == currentUser.password) {
      _showSnack('Mật khẩu mới không được trùng mật khẩu cũ',
          isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // ── Cập nhật password trong GlobalData + lưu storage ─────────
    final idx = GlobalData.users
        .indexWhere((u) => u.email == currentUser.email);
    if (idx != -1) {
      GlobalData.users[idx].password = _newPwController.text.trim();
      await StorageService.saveUsers(GlobalData.users);
      // Cập nhật currentUser trong storage
      await StorageService.saveCurrentUser(GlobalData.users[idx]);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      _showSnack('Đổi mật khẩu thành công!');
      Navigator.pop(context);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? Colors.red : const Color(0xFF43A047),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Mật khẩu mới phải có ít nhất 8 ký tự',
                  style: TextStyle(
                      color: Color(0xFF999999), fontSize: 13),
                ),
                const SizedBox(height: 28),

                // ── Mật khẩu cũ ─────────────────────────────────
                _buildLabel('Mật khẩu cũ'),
                const SizedBox(height: 8),
                _buildPasswordField(
                  controller: _oldPwController,
                  hintText: 'Nhập mật khẩu cũ',
                  showPassword: _showOld,
                  onToggle: () =>
                      setState(() => _showOld = !_showOld),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Vui lòng nhập mật khẩu cũ'
                      : null,
                ),
                const SizedBox(height: 24),

                // ── Mật khẩu mới ────────────────────────────────
                _buildLabel('Mật khẩu mới'),
                const SizedBox(height: 8),
                _buildPasswordField(
                  controller: _newPwController,
                  hintText: 'Nhập mật khẩu mới',
                  showPassword: _showNew,
                  onToggle: () =>
                      setState(() => _showNew = !_showNew),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Vui lòng nhập mật khẩu mới';
                    if (v.length < 8)
                      return 'Mật khẩu phải có ít nhất 8 ký tự';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // ── Xác nhận mật khẩu ───────────────────────────
                _buildLabel('Xác nhận mật khẩu mới'),
                const SizedBox(height: 8),
                _buildPasswordField(
                  controller: _confirmPwController,
                  hintText: 'Nhập lại mật khẩu mới',
                  showPassword: _showConfirm,
                  onToggle: () =>
                      setState(() => _showConfirm = !_showConfirm),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Vui lòng xác nhận mật khẩu';
                    if (v != _newPwController.text)
                      return 'Mật khẩu không khớp';
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // ── Độ mạnh mật khẩu ────────────────────────────
                _buildPasswordStrength(),

                const SizedBox(height: 32),

                // ── Nút lưu ─────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEB7E35),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'Lưu thay đổi',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Color(0xFF333333),
          fontSize: 14,
          fontWeight: FontWeight.w600),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool showPassword,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      validator: validator,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color(0xFFCCCCCC), fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color(0xFFEB7E35), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Colors.red, width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            showPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xFFCCCCCC),
            size: 20,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildPasswordStrength() {
    final pw = _newPwController.text;
    if (pw.isEmpty) return const SizedBox.shrink();

    int strength = 0;
    if (pw.length >= 8) strength++;
    if (pw.contains(RegExp(r'[A-Z]'))) strength++;
    if (pw.contains(RegExp(r'[0-9]'))) strength++;
    if (pw.contains(RegExp(r'[!@#$%^&*]'))) strength++;

    final labels = ['Yếu', 'Trung bình', 'Mạnh', 'Rất mạnh'];
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.blue,
      Colors.green
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Độ mạnh: ${strength > 0 ? labels[strength - 1] : "Yếu"}',
          style: TextStyle(
            color: strength > 0 ? colors[strength - 1] : Colors.red,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(
            4,
            (i) => Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                height: 4,
                decoration: BoxDecoration(
                  color: i < strength
                      ? colors[strength - 1]
                      : const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}