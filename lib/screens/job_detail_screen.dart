import 'package:flutter/material.dart';
import '../models/job_model.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null || args is! Job) {
      return const Scaffold(body: Center(child: Text("Lỗi: Không có dữ liệu công việc")));
    }
    final job = args as Job;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 124,
                decoration: ShapeDecoration(
                  color: const Color(0xFF97C3DF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(42)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(job.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(job.company, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  _buildInfoTile("Lương:", job.salary),
                  _buildInfoTile("Địa điểm:", job.location),
                ],
              ),
              const SizedBox(height: 16),

              _buildExpandableSection(
                Icons.description_outlined, 
                "Mô tả công việc",
                job.description,
              ),
              const SizedBox(height: 8),
              _buildExpandableSection(
                Icons.checklist, 
                "Yêu cầu từ nhà tuyển dụng",
                job.requirements,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context, 
              '/ung-tuyen', 
              arguments: job,
            );
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFF7526),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Text("Ứng tuyển ngay", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Expanded(
      child: Container(
        height: 90,
        decoration: BoxDecoration(color: const Color(0xFFD9D9D9), border: Border.all(color: Colors.white)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(IconData icon, String title, String content) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      collapsedBackgroundColor: const Color(0xFFD9D9D9),
      backgroundColor: const Color(0xFFD9D9D9),
      leading: Icon(icon, color: Colors.blue, size: 30),
      title: Text(title, style: const TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Text(
            content.isEmpty ? "Chưa có thông tin" : content,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ),
      ],
    );
  }
}