import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class RegisterSvStep3Screen extends StatefulWidget {
  const RegisterSvStep3Screen({super.key});

  @override
  State<RegisterSvStep3Screen> createState() => _RegisterSvStep3ScreenState();
}

class _RegisterSvStep3ScreenState extends State<RegisterSvStep3Screen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final List<String> _allSkills = [
    'Giao tiếp', 'Tiếng Anh', 'Lái xe', 'Excel',
    'Word', 'Photoshop', 'Marketing', 'Lập trình', 'Figma'
  ];
  final Set<String> _selectedSkills = {};

  double _luongMin = 5000000;
  double _luongMax = 15000000;

  final Set<String> _thoiGianSelected = {};
  final List<Map<String, String>> _thoiGianOptions = [
    {'label': 'Sáng (8-12h)', 'value': 'sang'},
    {'label': 'Chiều (13-17h)', 'value': 'chieu'},
    {'label': 'Tối (18-22h)', 'value': 'toi'},
    {'label': 'Cuối tuần', 'value': 'cuoi_tuan'},
  ];

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Lỗi chọn ảnh: $e");
    }
  }

  String _formatMoney(double value) {
    return '${(value / 1000000).toStringAsFixed(0)} Tr';
  }

  // --- HÀM XỬ LÝ KHI NHẤN HOÀN TẤT ---
void _onComplete() async {  // ✅ Thêm async
  if (_selectedSkills.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vui lòng chọn ít nhất 1 kỹ năng')),
    );
    return;
  }

  final userProvider = Provider.of<UserProvider>(context, listen: false);
  
  await userProvider.updateFinalStep(  // ✅ Thêm await
    newSkills: _selectedSkills.toList(),
    newAvatar: _imageFile,
    salaryMin: _luongMin,      // ✅ Thêm các trường còn thiếu
    salaryMax: _luongMax,
    availableTime: _thoiGianSelected.toList(),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Đăng ký hồ sơ thành công!'),
      backgroundColor: Colors.green,
    ),
  );
  
  Navigator.pushNamedAndRemoveUntil(context, '/student-home', (route) => false); 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        title: const Text('Hoàn tất hồ sơ', 
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Thanh tiến trình
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: List.generate(3, (i) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4779BB), 
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- AVATAR ---
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1), 
                                        blurRadius: 10,
                                        offset: const Offset(0, 4)
                                      )
                                    ]
                                  ),
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundColor: const Color(0xFFE0E0E0),
                                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                                    child: _imageFile == null 
                                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                                      : null,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0, right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(color: Color(0xFFEB7E35), shape: BoxShape.circle),
                                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('Tải lên ảnh đại diện', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- KỸ NĂNG ---
                    _buildSectionTitle('Kỹ năng của bạn'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _allSkills.map((skill) {
                        final isSelected = _selectedSkills.contains(skill);
                        return ChoiceChip(
                          label: Text(skill),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) _selectedSkills.add(skill);
                              else _selectedSkills.remove(skill);
                            });
                          },
                          selectedColor: const Color(0xFF4779BB),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 13,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // --- LƯƠNG ---
                    _buildSectionTitle('Mức lương mong muốn (VND)'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatMoney(_luongMin), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4779BB))),
                              const Text('đến', style: TextStyle(color: Colors.grey)),
                              Text(_formatMoney(_luongMax), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4779BB))),
                            ],
                          ),
                          RangeSlider(
                            values: RangeValues(_luongMin, _luongMax),
                            min: 1000000, max: 50000000,
                            divisions: 49,
                            activeColor: const Color(0xFF4779BB),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _luongMin = values.start;
                                _luongMax = values.end;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- THỜI GIAN ---
                    _buildSectionTitle('Thời gian có thể làm việc'),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.5,
                      ),
                      itemCount: _thoiGianOptions.length,
                      itemBuilder: (context, index) {
                        final opt = _thoiGianOptions[index];
                        final isSel = _thoiGianSelected.contains(opt['value']);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSel) _thoiGianSelected.remove(opt['value']);
                              else _thoiGianSelected.add(opt['value']!);
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF4779BB) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSel ? const Color(0xFF4779BB) : const Color(0xFFEEEEEE)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              opt['label']!,
                              style: TextStyle(
                                color: isSel ? Colors.white : Colors.black87, 
                                fontWeight: isSel ? FontWeight.bold : FontWeight.normal
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 48),

                    // --- NÚT HOÀN TẤT ---
                    SizedBox(
                      width: double.infinity, height: 56,
                      child: ElevatedButton(
                        onPressed: _onComplete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEB7E35), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                        ),
                        child: const Text('HOÀN TẤT ĐĂNG KÝ', 
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87));
  }
}