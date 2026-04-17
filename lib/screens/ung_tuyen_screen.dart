// screens/ung_tuyen_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/job_model.dart';
import '../models/global_data.dart';

class UngTuyenScreen extends StatefulWidget {
  const UngTuyenScreen({super.key});

  @override
  State<UngTuyenScreen> createState() => _UngTuyenScreenState();
}

class _UngTuyenScreenState extends State<UngTuyenScreen> {
  final _thuController = TextEditingController();
  bool _dinhKemCV = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _thuController.dispose();
    super.dispose();
  }

  void _xuLyUngTuyen(Job job) async {  // ✅ Thêm async
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lỗi: Bạn chưa đăng nhập'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // ✅ SỬA: Chỉ còn 2 tham số + thêm await
    final success = await GlobalData.applyForJob(
      job.id,
      currentUser.email,
    );

    setState(() => _isSubmitting = false);

    if (!success) {
      // Đã ứng tuyển rồi
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.info, color: Colors.orange),
              SizedBox(width: 10),
              Text("Thông báo"),
            ],
          ),
          content: const Text("Bạn đã ứng tuyển công việc này rồi."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );
      return;
    }

    // Hiển thị thông báo thành công
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text("Thành công!"),
          ],
        ),
        content: Text("Bạn đã gửi đơn ứng tuyển vào vị trí ${job.title} thành công."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // Quay về trang trước
            },
            child: const Text("OK",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... giữ nguyên phần build ...
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Job) {
      return const Scaffold(
        body: Center(child: Text("Lỗi: Không tìm thấy thông tin công việc")),
      );
    }
    final job = args as Job;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Đơn ứng tuyển",
            style: TextStyle(fontSize: 18, color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Card thông tin công việc
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("VỊ TRÍ ỨNG TUYỂN",
                        style: TextStyle(
                            color: Color(0xFFD34600),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(job.title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("${job.company} • ${job.location}",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Thư giới thiệu bản thân",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),

            // Ô nhập thư giới thiệu
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: TextField(
                    controller: _thuController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: "Nhập nội dung thư giới thiệu của bạn tại đây...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
              ),
            ),

            // Switch đính kèm CV
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              title: const Text("Đính kèm CV từ hồ sơ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              trailing: Switch(
                value: _dinhKemCV,
                activeColor: const Color(0xFF2F4ECC),
                onChanged: (val) => setState(() => _dinhKemCV = val),
              ),
            ),

            // Nút gửi đơn
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F4ECC),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35)),
                    elevation: 0,
                  ),
                  onPressed: _isSubmitting ? null : () => _xuLyUngTuyen(job),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Gửi đơn ứng tuyển",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}