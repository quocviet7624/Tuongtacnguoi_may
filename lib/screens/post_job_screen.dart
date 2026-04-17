import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/job_model.dart';
import '../models/global_data.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final _jobNameCtrl = TextEditingController();
  String? _selectedCategory;
  final _descCtrl = TextEditingController();
  final _requirementCtrl = TextEditingController();

  final _salaryCtrl = TextEditingController();
  String _selectedShift = 'Toàn thời gian';
  final _locationCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _jobNameCtrl.dispose();
    _descCtrl.dispose();
    _requirementCtrl.dispose();
    _salaryCtrl.dispose();
    _locationCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep == 0) {
      if (_jobNameCtrl.text.trim().isEmpty) {
        _showSnack('Vui lòng nhập tên công việc');
        return;
      }
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentStep = 1);
    } else {
      _submitJob();
    }
  }

  void _prevPage() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => _currentStep = 0);
  }

  void _submitJob() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser == null) {
      _showSnack('Lỗi: Chưa đăng nhập');
      return;
    }

    final newJob = Job(
      title: _jobNameCtrl.text.trim(),
      company: currentUser.companyName ?? currentUser.fullName ?? 'Công ty',
      salary: _salaryCtrl.text.trim().isEmpty
          ? 'Thỏa thuận'
          : '${_salaryCtrl.text.trim()}đ/giờ',
      location: _locationCtrl.text.trim().isEmpty
          ? (currentUser.address ?? 'Đà Nẵng')
          : _locationCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty
          ? 'Chưa có mô tả chi tiết'
          : _descCtrl.text.trim(),
      requirements: _requirementCtrl.text.trim().isEmpty
          ? 'Không có yêu cầu đặc biệt'
          : _requirementCtrl.text.trim(),
      category: _selectedCategory ?? 'Khác',
      shift: _selectedShift,
      quantity: int.tryParse(_quantityCtrl.text.trim()) ?? 1,
      employerEmail: currentUser.email,
    );

    try {
      await GlobalData.addJob(newJob);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Đăng tin thành công!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Trả về true để báo thành công
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Lỗi khi lưu job: $e');
      if (mounted) _showSnack('Lỗi lưu dữ liệu: $e');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5C5C5A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Đăng tin tuyển dụng',
          style: TextStyle(
              color: Color(0xFF5C5C5A),
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter'),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bước ${_currentStep + 1}/2: ${_currentStep == 0 ? "Thông tin công việc" : "Chi tiết & Đăng"}',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5E5E5C),
                      fontFamily: 'Inter'),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentStep + 1) / 2,
                  backgroundColor: const Color(0xFFE5E7EB),
                  color: const Color(0xFFEB7E35),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _Step1(
                  jobNameCtrl: _jobNameCtrl,
                  descCtrl: _descCtrl,
                  requirementCtrl: _requirementCtrl,
                  selectedCategory: _selectedCategory,
                  onCategoryChanged: (v) => setState(() => _selectedCategory = v),
                  onNext: _nextPage,
                ),
                _Step2(
                  salaryCtrl: _salaryCtrl,
                  locationCtrl: _locationCtrl,
                  quantityCtrl: _quantityCtrl,
                  selectedShift: _selectedShift,
                  onShiftChanged: (v) => setState(() => _selectedShift = v),
                  onSubmit: _nextPage,
                  onBack: _prevPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── STEP 1 ──────────────────────────────────────────────────────────────────
class _Step1 extends StatelessWidget {
  final TextEditingController jobNameCtrl, descCtrl, requirementCtrl;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onNext;

  const _Step1({
    required this.jobNameCtrl,
    required this.descCtrl,
    required this.requirementCtrl,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel('Tên công việc *'),
          _InputBox(controller: jobNameCtrl, hint: 'VD: Nhân viên Marketing, Lập trình viên...'),
          const SizedBox(height: 16),
          _FieldLabel('Danh mục'),
          _DropdownBox(
            value: selectedCategory,
            hint: 'Chọn danh mục',
            items: const [
              'Kinh doanh',
              'Công nghệ thông tin',
              'Marketing',
              'Kế toán',
              'Nhà hàng - Khách sạn',
              'Giáo dục',
              'Thiết kế',
              'Khác',
            ],
            onChanged: onCategoryChanged,
          ),
          const SizedBox(height: 16),
          _FieldLabel('Mô tả công việc'),
          _TextAreaBox(
              controller: descCtrl,
              hint: 'Mô tả chi tiết công việc, môi trường làm việc...'),
          const SizedBox(height: 16),
          _FieldLabel('Yêu cầu ứng viên'),
          _TextAreaBox(
              controller: requirementCtrl,
              hint: 'Kinh nghiệm, kỹ năng, bằng cấp cần thiết...'),
          const SizedBox(height: 28),
          _OrangeButton(label: 'Tiếp tục →', onTap: onNext),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── STEP 2 ──────────────────────────────────────────────────────────────────
class _Step2 extends StatelessWidget {
  final TextEditingController salaryCtrl, locationCtrl, quantityCtrl;
  final String selectedShift;
  final ValueChanged<String> onShiftChanged;
  final VoidCallback onSubmit, onBack;

  const _Step2({
    required this.salaryCtrl,
    required this.locationCtrl,
    required this.quantityCtrl,
    required this.selectedShift,
    required this.onShiftChanged,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    const shifts = [
      'Sáng 7-12h',
      'Chiều 13-17h',
      'Tối 18-22h',
      'Bán thời gian',
      'Toàn thời gian',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel('Mức lương'),
          _InputBox(
              controller: salaryCtrl,
              hint: 'VD: 5.000.000 - 8.000.000đ hoặc Thỏa thuận'),
          const SizedBox(height: 16),
          _FieldLabel('Ca làm việc'),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAF9F7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E2E0)),
            ),
            child: Column(
              children: shifts.map((s) {
                return RadioListTile<String>(
                  dense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12),
                  title: Text(s,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B6C6A),
                          fontFamily: 'Inter')),
                  value: s,
                  groupValue: selectedShift,
                  activeColor: const Color(0xFFEB7E35),
                  onChanged: (v) => onShiftChanged(v!),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _FieldLabel('Địa điểm làm việc'),
          _InputBox(
              controller: locationCtrl,
              hint: 'VD: Hải Châu, Đà Nẵng (để trống dùng địa chỉ công ty)'),
          const SizedBox(height: 16),
          _FieldLabel('Số lượng tuyển'),
          _InputBox(
              controller: quantityCtrl, hint: 'Nhập số người cần tuyển'),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFFA7BACD), width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('← Quay lại',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB6F28),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                  ),
                  child: const Text('ĐĂNG TIN',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── SHARED WIDGETS ───────────────────────────────────────────────────────────

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
            color: Color(0xFF8E8E8D), fontSize: 14, fontFamily: 'Inter'),
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
            borderSide:
                const BorderSide(color: Color(0xFFEB7E35), width: 1.5)),
      ),
    );
  }
}

class _TextAreaBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _TextAreaBox({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      style: const TextStyle(fontSize: 15, fontFamily: 'Inter'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            color: Color(0xFF8E8E8D), fontSize: 14, fontFamily: 'Inter'),
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
            borderSide:
                const BorderSide(color: Color(0xFFEB7E35), width: 1.5)),
      ),
    );
  }
}

class _DropdownBox extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownBox(
      {required this.value,
      required this.hint,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E2E0), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint,
              style: const TextStyle(
                  color: Color(0xFF8E8E8D),
                  fontSize: 14,
                  fontFamily: 'Inter')),
          items: items
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e,
                      style: const TextStyle(
                          fontSize: 15, fontFamily: 'Inter'))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _OrangeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OrangeButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF732B),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}