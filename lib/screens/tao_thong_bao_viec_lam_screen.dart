import 'package:flutter/material.dart';

class TaoThongBaoViecLamScreen extends StatefulWidget {
  const TaoThongBaoViecLamScreen({super.key});

  @override
  State<TaoThongBaoViecLamScreen> createState() => _TaoThongBaoViecLamScreenState();
}

class _TaoThongBaoViecLamScreenState extends State<TaoThongBaoViecLamScreen> {
  final _tuKhoaController = TextEditingController();
  final _luongController = TextEditingController();
  final _diaDiemController = TextEditingController();

  String _selectedNganh = '';
  int _selectedFreq = 0; // 0=Ngay lập tức, 1=Hàng ngày, 2=Hàng tuần
  bool _isLoading = false;

  final List<String> _nganhList = [
    'Kinh doanh',
    'Công nghệ thông tin',
    'Marketing',
    'Kế toán - Tài chính',
    'Nhân sự',
    'Thiết kế',
    'Giáo dục',
    'Khác',
  ];

  @override
  void dispose() {
    _tuKhoaController.dispose();
    _luongController.dispose();
    _diaDiemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2196F3), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tạo thông báo việc làm',
          style: TextStyle(
            color: Color(0xFF2196F3),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thiết lập thông báo để nhận tin việc làm phù hợp với bạn nhất.',
              style: TextStyle(color: Color(0xFF888888), fontSize: 13),
            ),
            const SizedBox(height: 28),

            // Từ khóa
            _buildLabel('Từ khóa'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _tuKhoaController,
              hint: 'Nhập từ khóa...',
              prefixIcon: Icons.search,
            ),
            const SizedBox(height: 20),

            // Ngành nghề
            _buildLabel('Ngành nghề'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showNganhPicker(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.business_center_outlined, color: const Color(0xFFAAAAAA), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedNganh.isEmpty ? 'Chọn ngành nghề' : _selectedNganh,
                        style: TextStyle(
                          color: _selectedNganh.isEmpty ? const Color(0xFFAAAAAA) : Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFFAAAAAA), size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Mức lương
            _buildLabel('Mức lương'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _luongController,
              hint: 'Nhập mức lương mong muốn...',
              prefixIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Địa điểm
            _buildLabel('Địa điểm'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _diaDiemController,
              hint: 'Nhập địa điểm...',
              prefixIcon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 24),

            // Tần suất thông báo
            _buildLabel('Tần suất thông báo'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  _buildFreqTab('Ngay lập tức', 0),
                  _buildFreqTab('Hàng ngày', 1),
                  _buildFreqTab('Hàng tuần', 2),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // Frequency description
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEB7E35).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFFEB7E35), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getFreqDescription(),
                      style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Lưu thông báo',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Color(0xFF333333), fontSize: 13, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
        prefixIcon: Icon(prefixIcon, color: const Color(0xFFAAAAAA), size: 18),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildFreqTab(String label, int index) {
    final isSelected = _selectedFreq == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFreq = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2196F3) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }

  String _getFreqDescription() {
    switch (_selectedFreq) {
      case 0: return 'Bạn sẽ nhận thông báo ngay khi có việc làm mới phù hợp.';
      case 1: return 'Bạn sẽ nhận tổng hợp thông báo vào 8:00 sáng mỗi ngày.';
      case 2: return 'Bạn sẽ nhận tổng hợp thông báo vào sáng thứ Hai hàng tuần.';
      default: return '';
    }
  }

  void _showNganhPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('Chọn ngành nghề', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _nganhList.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => ListTile(
                title: Text(_nganhList[i]),
                trailing: _selectedNganh == _nganhList[i]
                    ? const Icon(Icons.check, color: Color(0xFF2196F3))
                    : null,
                onTap: () {
                  setState(() => _selectedNganh = _nganhList[i]);
                  Navigator.pop(ctx);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_tuKhoaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập từ khóa')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu thông báo việc làm!'),
          backgroundColor: Color(0xFF43A047),
        ),
      );
      Navigator.pop(context);
    }
  }
}