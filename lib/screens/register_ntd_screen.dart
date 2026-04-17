import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/global_data.dart';

class RegisterNtdScreen extends StatefulWidget {
  const RegisterNtdScreen({super.key});

  @override
  State<RegisterNtdScreen> createState() => _RegisterNtdScreenState();
}

class _RegisterNtdScreenState extends State<RegisterNtdScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _tenCtyCtrl = TextEditingController();
  final _diaChiCtrl = TextEditingController();
  final _mstCtrl = TextEditingController();
  final _nguoiDDCtrl = TextEditingController();
  final _sdtCtrl = TextEditingController();
  String? _loaiHinh;
  bool _obscure = true;

  final List<String> _loaiHinhList = [
    'Công ty TNHH',
    'Công ty Cổ phần',
    'Doanh nghiệp tư nhân',
    'Tập đoàn',
    'Startup',
  ];

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _tenCtyCtrl.dispose();
    _diaChiCtrl.dispose();
    _mstCtrl.dispose();
    _nguoiDDCtrl.dispose();
    _sdtCtrl.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;
    if (_loaiHinh == null) {
      _showSnack('Vui lòng chọn loại hình công ty');
      return;
    }

    // Kiểm tra email trùng
    if (GlobalData.emailExists(_emailCtrl.text.trim())) {
      _showSnack('Email này đã được đăng ký');
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.createEmployerAccount(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
      phone: _sdtCtrl.text.trim(),
      companyName: _tenCtyCtrl.text.trim(),
      address: _diaChiCtrl.text.trim(),
      taxCode: _mstCtrl.text.trim(),
      representative: _nguoiDDCtrl.text.trim(),
      businessType: _loaiHinh!,
    );

    // Hiển thị thông báo thành công và chuyển thẳng vào app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Đăng ký thành công!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushNamedAndRemoveUntil(context, '/employer-home', (route) => false);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    String hint = '',
    TextInputType? type,
    bool obscure = false,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: type,
          obscureText: obscure,
          validator: validator ??
              (value) {
                if (value == null || value.trim().isEmpty) return 'Không được để trống';
                return null;
              },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEB7E35), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Đăng ký Nhà Tuyển Dụng',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thông tin đăng nhập
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEB7E35).withOpacity(0.3)),
                  ),
                  child: const Text(
                    '📋 Thông tin tài khoản',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFEB7E35)),
                  ),
                ),
                const SizedBox(height: 16),

                _buildField('Email đăng nhập', _emailCtrl,
                    hint: 'company@example.com',
                    type: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Không được để trống';
                      if (!v.contains('@')) return 'Email không hợp lệ';
                      return null;
                    }),

                _buildField('Mật khẩu', _passCtrl,
                    hint: 'Ít nhất 6 ký tự',
                    obscure: _obscure,
                    suffix: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.grey, size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 6) return 'Mật khẩu ít nhất 6 ký tự';
                      return null;
                    }),

                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF4779BB).withOpacity(0.3)),
                  ),
                  child: const Text(
                    '🏢 Thông tin doanh nghiệp',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF4779BB)),
                  ),
                ),
                const SizedBox(height: 16),

                _buildField('Tên công ty', _tenCtyCtrl, hint: 'Nhập tên công ty'),

                // Loại hình
                const Text('Loại hình',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _loaiHinh,
                  hint: const Text('Chọn loại hình', style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14)),
                  items: _loaiHinhList
                      .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (v) => setState(() => _loaiHinh = v),
                  validator: (v) => v == null ? 'Vui lòng chọn loại hình' : null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEB7E35)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _buildField('Địa chỉ tại Đà Nẵng', _diaChiCtrl, hint: 'Số nhà, đường, quận...'),
                _buildField('Mã số thuế', _mstCtrl,
                    hint: 'Nhập mã số thuế', type: TextInputType.number),
                _buildField('Người đại diện', _nguoiDDCtrl, hint: 'Họ và tên người đại diện'),
                _buildField('SĐT liên hệ', _sdtCtrl,
                    hint: 'Nhập số điện thoại',
                    type: TextInputType.phone,
                    validator: (v) {
                      if (v == null || v.length < 10) return 'Số điện thoại không hợp lệ';
                      return null;
                    }),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEB7E35),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Hoàn tất đăng ký',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}