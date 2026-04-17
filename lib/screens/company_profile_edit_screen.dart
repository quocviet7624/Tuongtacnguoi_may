import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class CompanyProfileEditScreen extends StatefulWidget {
  const CompanyProfileEditScreen({super.key});

  @override
  State<CompanyProfileEditScreen> createState() =>
      _CompanyProfileEditScreenState();
}

class _CompanyProfileEditScreenState
    extends State<CompanyProfileEditScreen> {
  final _nameCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _taxCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user =
        Provider.of<UserProvider>(context, listen: false).currentUser;
    if (user != null) {
      _nameCtrl.text = user.companyName ?? '';
      _typeCtrl.text = user.businessType ?? '';
      _addressCtrl.text = user.address ?? '';
      // ✅ Dùng ?? '' để tránh lỗi String? → String
      _phoneCtrl.text = user.phone ?? '';
      _taxCtrl.text = user.taxCode ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _typeCtrl.dispose();
    _addressCtrl.dispose();
    _descCtrl.dispose();
    _phoneCtrl.dispose();
    _taxCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.updateProfile(
      companyName: _nameCtrl.text.trim().isEmpty
          ? null
          : _nameCtrl.text.trim(),
      businessType: _typeCtrl.text.trim().isEmpty
          ? null
          : _typeCtrl.text.trim(),
      address: _addressCtrl.text.trim().isEmpty
          ? null
          : _addressCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty
          ? null
          : _phoneCtrl.text.trim(),
      taxCode: _taxCtrl.text.trim().isEmpty
          ? null
          : _taxCtrl.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Đã lưu thông tin công ty!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thông tin công ty',
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter'),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Lưu',
                style: TextStyle(
                    color: Color(0xFFEB7E35),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Consumer<UserProvider>(
                    builder: (_, provider, __) {
                      final name =
                          provider.currentUser?.companyName ?? 'C';
                      return CircleAvatar(
                        radius: 44,
                        backgroundColor: const Color(0xFFEB7E35),
                        child: Text(
                          name.isNotEmpty
                              ? name[0].toUpperCase()
                              : 'C',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined,
                        size: 16, color: Color(0xFF666666)),
                    label: const Text('Tải lên logo',
                        style: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: 'Inter')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            _FieldLabel('Tên công ty'),
            _InputBox(
                controller: _nameCtrl, hint: 'Nhập tên công ty'),
            const SizedBox(height: 16),

            _FieldLabel('Loại hình kinh doanh'),
            _InputBox(
                controller: _typeCtrl,
                hint: 'VD: Công ty TNHH, Cổ phần...'),
            const SizedBox(height: 16),

            _FieldLabel('Mã số thuế'),
            _InputBox(
                controller: _taxCtrl, hint: 'Nhập mã số thuế'),
            const SizedBox(height: 16),

            _FieldLabel('Địa chỉ (Đà Nẵng)'),
            _InputBox(
                controller: _addressCtrl,
                hint: 'Số nhà, đường, quận, TP Đà Nẵng'),
            const SizedBox(height: 16),

            _FieldLabel('Số điện thoại liên hệ'),
            _InputBox(
                controller: _phoneCtrl, hint: '09xxxxxxxx'),
            const SizedBox(height: 16),

            _FieldLabel('Giới thiệu công ty'),
            _TextAreaBox(
                controller: _descCtrl,
                hint:
                    'Mô tả về công ty, văn hóa, lĩnh vực hoạt động...'),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF732B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(29)),
                ),
                child: const Text('LƯU THAY ĐỔI',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4E4E4C),
                fontFamily: 'Inter')),
      );
}

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _InputBox({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 15, fontFamily: 'Inter'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            color: Color(0xFF8E8E8D),
            fontSize: 14,
            fontFamily: 'Inter'),
        filled: true,
        fillColor: const Color(0xFFFAF9F7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE2E2E0))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE2E2E0))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
                color: Color(0xFFEB7E35), width: 1.5)),
      ),
    );
  }
}

class _TextAreaBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _TextAreaBox(
      {required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      style: const TextStyle(fontSize: 15, fontFamily: 'Inter'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            color: Color(0xFF8E8E8D),
            fontSize: 14,
            fontFamily: 'Inter'),
        filled: true,
        fillColor: const Color(0xFFFAF8F6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFE9E8E5))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFE9E8E5))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
                color: Color(0xFFEB7E35), width: 1.5)),
      ),
    );
  }
}