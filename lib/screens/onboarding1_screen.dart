import 'package:flutter/material.dart';

class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            // Căn giữa toàn bộ Column theo trục dọc
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(), // Đẩy nội dung vào giữa
              
              // Khối hình ảnh/icon
              Container(
                width: 280, // Giảm nhẹ kích thước để cân đối hơn trên nhiều màn hình
                height: 280,
                decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.circular(24)), // Bo góc mềm mại hơn
                child: const Center(
                    child: Icon(Icons.work_outline,
                        size: 100, color: Color(0xFF4B75DE))),
              ),
              
              const SizedBox(height: 48), // Khoảng cách từ hình đến chữ
              
              const Text(
                'Tìm việc nhanh\nLàm ngay hôm nay',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28, // 32 hơi to, 28-30 sẽ tinh tế hơn
                  fontWeight: FontWeight.bold,
                  height: 1.2, // Khoảng cách giữa 2 dòng chữ
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Thêm công việc phù hợp chỉ trong vài bước',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              
              const Spacer(), // Đẩy nút bấm xuống phía dưới một chút
              
              // Nút bấm
              SizedBox(
                width: double.infinity, // Để nút tự dãn theo padding của màn hình
                height: 56, // Chiều cao chuẩn cho các nút Mobile hiện đại
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/onboarding2'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B75DE),
                      elevation: 0, // Bỏ bóng đổ nếu muốn giao diện Flat
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: const Text('Next',
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 18, 
                        fontWeight: FontWeight.w600
                      )),
                ),
              ),
              
              const SizedBox(height: 20), // Khoảng cách an toàn cuối màn hình
            ],
          ),
        ),
      ),
    );
  }
}