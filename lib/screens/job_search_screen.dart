import 'package:flutter/material.dart';
import '../models/global_data.dart';
import '../models/job_model.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ── Trạng thái bộ lọc hiện tại ──────────────────────────────
  Map<String, dynamic>? _activeFilter;

  bool get _hasFilter =>
      _activeFilter != null &&
      (_activeFilter!['areas'] as List).isNotEmpty ||
      (_activeFilter != null &&
          (_activeFilter!['shifts'] as List).isNotEmpty);

  List<Job> get _filteredJobs {
    var jobs = GlobalData.getAllJobs();

    // Lọc theo từ khóa tìm kiếm
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      jobs = jobs.where((job) {
        return job.title.toLowerCase().contains(q) ||
            job.company.toLowerCase().contains(q) ||
            job.location.toLowerCase().contains(q) ||
            job.category.toLowerCase().contains(q);
      }).toList();
    }

    // Lọc theo bộ lọc
    if (_activeFilter != null) {
      final type = _activeFilter!['type'] as String?;
      final salaryMin = _activeFilter!['salaryMin'] as double?;
      final salaryMax = _activeFilter!['salaryMax'] as double?;
      final areas = (_activeFilter!['areas'] as List).cast<String>();
      final shifts = (_activeFilter!['shifts'] as List).cast<String>();

      jobs = jobs.where((job) {
        // Lọc loại công việc
        if (type != null && type.isNotEmpty) {
          // So sánh linh hoạt: shift của job chứa type hoặc ngược lại
          final jobShift = job.shift.toLowerCase();
          final filterType = type.toLowerCase();
          if (!jobShift.contains(filterType) &&
              !filterType.contains(jobShift)) {
            return false;
          }
        }

        // Lọc khu vực (nếu có chọn)
        if (areas.isNotEmpty) {
          final jobLoc = job.location.toLowerCase();
          final matchArea = areas.any(
              (a) => jobLoc.contains(a.toLowerCase()));
          if (!matchArea) return false;
        }

        // Lọc ca làm (nếu có chọn) — so theo category hoặc description
        if (shifts.isNotEmpty) {
          final jobText =
              '${job.description} ${job.shift} ${job.category}'.toLowerCase();
          final matchShift = shifts.any(
              (s) => jobText.contains(s.toLowerCase()));
          if (!matchShift) return false;
        }

        return true;
      }).toList();
    }

    return jobs;
  }

  Future<void> _openFilter() async {
    final result = await Navigator.pushNamed(
      context,
      '/job-filter',
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() => _activeFilter = result);
    }
  }

  void _clearFilter() => setState(() => _activeFilter = null);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _filteredJobs;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tìm kiếm việc làm',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Thanh tìm kiếm ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
            child: Container(
              height: 63,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F3),
                border: Border.all(color: const Color(0xFF858585)),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(Icons.search, size: 28, color: Colors.grey),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) =>
                          setState(() => _searchQuery = v),
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm công việc ...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  // ✅ Nút lọc — đổi màu khi đang có filter
                  GestureDetector(
                    onTap: _openFilter,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _activeFilter != null
                            ? const Color(0xFF004E94)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.tune,
                        size: 28,
                        color: _activeFilter != null
                            ? Colors.white
                            : Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
              ),
            ),
          ),

          // ✅ Tag bộ lọc đang áp dụng
          if (_activeFilter != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 36,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                scrollDirection: Axis.horizontal,
                children: [
                  // Loại công việc
                  _FilterTag(
                    label: _activeFilter!['type'] as String,
                    color: const Color(0xFF004E94),
                  ),
                  // Khu vực
                  ...(_activeFilter!['areas'] as List<dynamic>)
                      .cast<String>()
                      .map((a) => _FilterTag(label: a)),
                  // Ca làm
                  ...(_activeFilter!['shifts'] as List<dynamic>)
                      .cast<String>()
                      .map((s) => _FilterTag(label: s)),
                  // Xóa tất cả
                  GestureDetector(
                    onTap: _clearFilter,
                    child: Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.close,
                              size: 14, color: Colors.red.shade400),
                          const SizedBox(width: 4),
                          Text(
                            'Xóa lọc',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade400,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ── Số kết quả ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tìm thấy ${jobs.length} việc làm',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ── Danh sách kết quả ─────────────────────────────────
          Expanded(
            child: jobs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        const Text(
                          'Không tìm thấy công việc nào',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        if (_activeFilter != null) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _clearFilter,
                            child: const Text('Xóa bộ lọc',
                                style:
                                    TextStyle(color: Color(0xFF004E94))),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) =>
                        _buildJobCard(jobs[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Job job) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/job-detail', arguments: job),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 40, 20, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.company,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.salary,
                    style: const TextStyle(
                      color: Color(0xFFFF5D00),
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.location,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            // Badge danh mục
            Positioned(
              left: 8,
              top: 6,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7200),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  job.category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            // Badge ca làm
            Positioned(
              right: 12,
              top: 6,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF004E94).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  job.shift,
                  style: const TextStyle(
                    color: Color(0xFF004E94),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filter tag widget ────────────────────────────────────────────────────────
class _FilterTag extends StatelessWidget {
  final String label;
  final Color? color;

  const _FilterTag({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFF6B7280);
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: c,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}