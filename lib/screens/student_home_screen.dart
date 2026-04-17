// screens/student_home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/job_model.dart';
import '../models/global_data.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  String _selectedCategory = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final String fullName = userProvider.currentUser?.fullName ?? "Bạn";
    final String userName = fullName.split(' ').last;

    // Lấy danh sách job từ GlobalData
    final allJobs = GlobalData.getAllJobs();
    
    // Lọc theo category
    final filteredJobs = _selectedCategory == 'Tất cả'
        ? allJobs
        : allJobs.where((job) => job.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 27, 26, 0),
                child: Text(
                  'Xin chào, $userName!',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.30,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSearchBar(context),
              const SizedBox(height: 16),
              _buildCategoryChips(context),
              const SizedBox(height: 20),

              // Hiển thị danh sách job từ GlobalData
              if (filteredJobs.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: Text(
                      'Chưa có tin tuyển dụng nào',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                ...filteredJobs.map((job) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildJobCard(
                    context: context,
                    job: job,
                    bgColor: _getBgColor(job.category),
                  ),
                )),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Color _getBgColor(String category) {
    switch (category) {
      case 'Kinh doanh':
        return const Color(0xFFF7F7F5);
      case 'Giáo dục':
        return const Color(0xFFF7F3F6);
      case 'Công nghệ':
        return const Color(0xFFF0F7FF);
      case 'Marketing':
        return const Color(0xFFFFF5F0);
      default:
        return const Color(0xFFF5F4F2);
    }
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/job-search'),
        child: Container(
          height: 60,
          decoration: ShapeDecoration(
            color: const Color(0xFFF9FAF7),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(36),
            ),
          ),
          child: const Row(
            children: [
              SizedBox(width: 18),
              Icon(Icons.search, size: 24, color: Colors.grey),
              SizedBox(width: 12),
              Text(
                'Tìm việc làm thêm ...',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context) {
    final categories = ['Tất cả', 'Kinh doanh', 'Công nghệ', 'Marketing', 'Giáo dục', 'Khác'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        children: categories.map((cat) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _buildChip(cat, isSelected: _selectedCategory == cat),
        )).toList(),
      ),
    );
  }

  Widget _buildJobCard({
    required BuildContext context,
    required Job job,
    required Color bgColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/job-detail', arguments: job);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: bgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.work_outline, size: 28, color: Color(0xFFEB7E35)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.salary,
                      style: const TextStyle(color: Color(0xFFEB7E35), fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.location,
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 85,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F6F4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Trang chủ', isActive: true, onTap: () {}),
          _buildNavItem(Icons.search, 'Tìm kiếm', onTap: () => Navigator.pushNamed(context, '/job-search')),
          _buildNavItem(Icons.assignment, 'Ứng tuyển', onTap: () => Navigator.pushNamed(context, '/viec-da-ung-tuyen')),
          _buildNavItem(Icons.person, 'Hồ sơ', onTap: () {
            Navigator.pushReplacementNamed(context, '/ho-so-sv');
          }),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFEB7E35) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: isSelected ? const Color(0xFFEB7E35) : const Color(0xFFC2C2C2)),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? const Color(0xFFEB7E35) : Colors.black45, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFFEB7E35) : Colors.black45,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}