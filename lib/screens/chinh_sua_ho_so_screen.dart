import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ChinhSuaHoSoScreen extends StatefulWidget {
  const ChinhSuaHoSoScreen({super.key});

  @override
  State<ChinhSuaHoSoScreen> createState() => _ChinhSuaHoSoScreenState();
}

class _ChinhSuaHoSoScreenState extends State<ChinhSuaHoSoScreen> {
  final _hoTenCtrl    = TextEditingController();
  final _sdtCtrl      = TextEditingController();
  final _truongCtrl   = TextEditingController();
  final _nganhCtrl    = TextEditingController();
  final _gpaCtrl      = TextEditingController();
  final _kyNangCtrl   = TextEditingController();

  List<String> _skills = [];

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().currentUser;
    if (user != null) {
      _hoTenCtrl.text  = user.fullName;
      _sdtCtrl.text    = user.phone;
      _truongCtrl.text = user.school ?? '';
      _nganhCtrl.text  = user.major ?? '';
      _gpaCtrl.text    = user.gpa?.toString() ?? '';
      _skills          = List.from(user.skills ?? []);
    }
  }

  @override
  void dispose() {
    _hoTenCtrl.dispose();  _sdtCtrl.dispose();
    _truongCtrl.dispose(); _nganhCtrl.dispose();
    _gpaCtrl.dispose();    _kyNangCtrl.dispose();
    super.dispose();
  }

  void _addSkill() {
    final s = _kyNangCtrl.text.trim();
    if (s.isEmpty) return;
    setState(() { _skills.add(s); _kyNangCtrl.clear(); });
  }

  void _save() {
    final gpa = double.tryParse(_gpaCtrl.text.trim());
    context.read<UserProvider>().updateProfile(
      fullName: _hoTenCtrl.text.trim(),
      phone:    _sdtCtrl.text.trim(),
      school:   _truongCtrl.text.trim(),
      major:    _nganhCtrl.text.trim(),
      gpa:      gpa,
      skills:   _skills,
    );
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu thay đổi!')));
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
        title: const Text('Chỉnh sửa hồ sơ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
            _buildField('Họ và tên', _hoTenCtrl),
            _buildField('Số điện thoại', _sdtCtrl,
                type: TextInputType.phone),
            _buildField('Trường đại học', _truongCtrl),
            _buildField('Chuyên ngành', _nganhCtrl),
            _buildField('GPA', _gpaCtrl,
                type: const TextInputType.numberWithOptions(decimal: true),
                hint: 'VD: 3.5'),

            // ── Kỹ năng ──────────────────────────────────────────────────
            const Text('Kỹ năng',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFDDDDDD)),
                    ),
                    child: TextField(
                      controller: _kyNangCtrl,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        hintText: 'VD: Tiếng Anh, Excel...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addSkill,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB7E35),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Thêm',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _skills.map((s) => Chip(
                    label: Text(s,
                        style: const TextStyle(color: Colors.white)),
                    backgroundColor: const Color(0xFF4779BB),
                    deleteIconColor: Colors.white70,
                    side: BorderSide.none,
                    onDeleted: () => setState(() => _skills.remove(s)),
                  )).toList(),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB7E35),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Lưu thay đổi',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl,
      {TextInputType? type, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDDDDDD)),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: type,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: hint,
              hintStyle:
                  const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}