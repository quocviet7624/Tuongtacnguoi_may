import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class RegisterSvStep2Screen extends StatefulWidget {
  const RegisterSvStep2Screen({super.key});

  @override
  State<RegisterSvStep2Screen> createState() => _RegisterSvStep2ScreenState();
}

class _RegisterSvStep2ScreenState extends State<RegisterSvStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();
  final _majorCtrl = TextEditingController();
  final _gpaCtrl = TextEditingController();

  final List<String> _schools = [
    'Đại học Kiến Trúc Đà Nẵng',
    'Đại học Bách khoa Đà Nẵng',
    'Đại học Kinh tế Đà Nẵng',
    'Đại học Sư phạm Đà Nẵng',
    'Đại học FPT Đà Nẵng',
    'Cao đẳng Công nghệ Đà Nẵng',
    'Trường khác',
  ];
  String? _selectedSchool;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _schoolCtrl.dispose();
    _majorCtrl.dispose();
    _gpaCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;

    double gpa = double.tryParse(_gpaCtrl.text.trim()) ?? 0.0;
    if (gpa < 0 || gpa > 4.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPA phải từ 0.0 đến 4.0'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.updateStudentInfo(
      fullName: _nameCtrl.text.trim(),
      school: _selectedSchool ?? _schoolCtrl.text.trim(),
      major: _majorCtrl.text.trim(),
      gpa: gpa,
    );

    Navigator.pushNamed(context, '/register-sv-3');
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
        title: const Text('Thông tin học vấn',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700)),
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
                // Progress bar
                Row(
                  children: List.generate(3, (i) => Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                      height: 6,
                      decoration: BoxDecoration(
                        color: i <= 1 ? const Color(0xFF4779BB) : const Color(0xFFDDDDDD),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  )),
                ),
                const SizedBox(height: 8),
                const Text('Bước 2/3: Thông tin học vấn',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 24),

                _buildField('Họ và tên', _nameCtrl, hint: 'Nguyễn Văn An'),

                // Trường học - Dropdown
                const Text('Trường học',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedSchool,
                  hint: const Text('Chọn trường', style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14)),
                  items: _schools
                      .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14))))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedSchool = v),
                  validator: (v) => v == null ? 'Vui lòng chọn trường' : null,
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
                      borderSide: const BorderSide(color: Color(0xFF4779BB)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _buildField('Ngành học', _majorCtrl, hint: 'Công nghệ thông tin'),

                _buildField('Điểm GPA', _gpaCtrl,
                    hint: '0.0 - 4.0',
                    type: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Không được để trống';
                      final d = double.tryParse(v);
                      if (d == null || d < 0 || d > 4) return 'GPA từ 0.0 đến 4.0';
                      return null;
                    }),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4779BB),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Tiếp theo →',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildField(String label, TextEditingController ctrl,
      {String hint = '', TextInputType? type, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: type,
          validator: validator ??
              (v) {
                if (v == null || v.trim().isEmpty) return 'Không được để trống';
                return null;
              },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4779BB), width: 1.5),
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
}