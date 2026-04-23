// screens/viec_da_ung_tuyen_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/global_data.dart';
import '../models/job_model.dart';
import 'ung_tuyen_detail_screen.dart';

class ViecDaUngTuyenScreen extends StatelessWidget {
  const ViecDaUngTuyenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    final appliedJobs = currentUser != null
        ? GlobalData.getAppliedJobs(currentUser.email)
        : <Job>[];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFA9D0E9)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Việc làm đã ứng tuyển',
          style: TextStyle(
            color: Color(0xFFA9D0E9),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: appliedJobs.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: appliedJobs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final job = appliedJobs[index];
                return _buildJobCard(context, job);
              },
            ),
    );
  }

  Widget _buildJobCard(BuildContext context, Job job) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UngTuyenDetailScreen(job: job),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(job.company,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(job.salary,
                      style: const TextStyle(
                          color: Color(0xFFEB7E35),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBBA1B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("Đang xem xét",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Xem chi tiết →',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFA9D0E9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("Bạn chưa ứng tuyển việc nào",
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}