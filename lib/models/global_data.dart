import 'job_model.dart';
import 'user_model.dart';

class GlobalData {
  GlobalData._();

  static final List<AppUser> users = [];
  static final List<Job> jobs = [];
  static final Map<String, List<String>> jobApplicants = {};
  static final Map<String, List<Job>> studentApplications = {};
  static final Map<String, List<Map<String, dynamic>>> messages = {};
  static final List<Map<String, dynamic>> conversations = [];

  static bool _seeded = false;

  // ─────────────────────────────────────────────────────────────────────────
  // SEED DỮ LIỆU DEMO — gọi một lần duy nhất trong main()
  // ─────────────────────────────────────────────────────────────────────────
  static void seedDemoData() {
    if (_seeded) return;
    _seeded = true;

    // Sinh viên demo
    final sv = AppUser(
      email: 'sv@gmail.com',
      password: '123456',
      role: UserRole.sinhVien,
      fullName: 'Nguyễn Văn An',
      phone: '0901234567',
      school: 'Đại học Đà Nẵng',
      major: 'Công nghệ thông tin',
      gpa: 3.5,
      skills: ['Flutter', 'Dart', 'Tiếng Anh', 'Figma'],
      salaryMin: 5000000,
      salaryMax: 10000000,
    );

    // Nhà tuyển dụng demo
    final ntd = AppUser(
      email: 'ntd@gmail.com',
      password: '123456',
      role: UserRole.nhaTuyenDung,
      fullName: 'Trần Thị Bình',
      phone: '0987654321',
      companyName: 'TechViệt Software',
      address: '123 Lê Duẩn, Hải Châu, Đà Nẵng',
      taxCode: '0401234567',
      representative: 'Trần Thị Bình',
      businessType: 'Công ty TNHH',
    );

    users.addAll([sv, ntd]);

    // Tin tuyển dụng demo
    final job1 = Job(
      title: 'Nhân viên Marketing',
      company: 'TechViệt Software',
      salary: '5.000.000 - 8.000.000đ',
      location: 'Hải Châu, Đà Nẵng',
      description: 'Tìm kiếm nhân viên Marketing sáng tạo, năng động, có khả năng lên ý tưởng và triển khai chiến dịch marketing hiệu quả.',
      requirements: 'Tốt nghiệp ngành Marketing hoặc liên quan. Có kinh nghiệm 1 năm. Thành thạo các công cụ digital marketing.',
      category: 'Marketing',
      shift: 'Toàn thời gian',
      quantity: 2,
      employerEmail: 'ntd@gmail.com',
      postedDate: DateTime.now().subtract(const Duration(days: 2)),
    );

    final job2 = Job(
      title: 'Thực tập sinh Flutter',
      company: 'TechViệt Software',
      salary: '3.000.000 - 5.000.000đ',
      location: 'Thanh Khê, Đà Nẵng',
      description: 'Cơ hội thực tập hấp dẫn cho sinh viên CNTT muốn học hỏi về lập trình mobile Flutter.',
      requirements: 'Biết Flutter/Dart cơ bản. Ham học hỏi. Có thể đi làm ít nhất 4 buổi/tuần.',
      category: 'Công nghệ thông tin',
      shift: 'Bán thời gian',
      quantity: 3,
      employerEmail: 'ntd@gmail.com',
      postedDate: DateTime.now().subtract(const Duration(days: 5)),
    );

    final job3 = Job(
      title: 'Nhân viên Kế toán',
      company: 'TechViệt Software',
      salary: '6.000.000 - 9.000.000đ',
      location: 'Hải Châu, Đà Nẵng',
      description: 'Phụ trách công tác kế toán tổng hợp, lập báo cáo tài chính hàng tháng.',
      requirements: 'Tốt nghiệp ngành Kế toán. Thành thạo Excel, phần mềm kế toán.',
      category: 'Kế toán',
      shift: 'Toàn thời gian',
      quantity: 1,
      employerEmail: 'ntd@gmail.com',
      postedDate: DateTime.now().subtract(const Duration(days: 1)),
    );

    jobs.addAll([job3, job1, job2]); // job3 mới nhất lên đầu

    // Demo: sv đã ứng tuyển job1
    jobApplicants[job1.id] = ['sv@gmail.com'];
    studentApplications['sv@gmail.com'] = [job1];
  }

  // ─────────────────────────────────────────────────────────────────────────
  // USER
  // ─────────────────────────────────────────────────────────────────────────

  static AppUser? findUser(String email, String password) {
    try {
      return users.firstWhere(
          (u) => u.email == email && u.password == password);
    } catch (_) {
      return null;
    }
  }

  static bool emailExists(String email) =>
      users.any((u) => u.email == email);

  static void addUser(AppUser user) => users.add(user);

  // ─────────────────────────────────────────────────────────────────────────
  // JOB
  // ─────────────────────────────────────────────────────────────────────────

  static void addJob(Job job) => jobs.insert(0, job);

  static List<Job> getAllJobs() => List.from(jobs);

  static List<Job> getJobsByEmployer(String email) =>
      jobs.where((j) => j.employerEmail == email).toList();

  static Job? getJobById(String id) {
    try {
      return jobs.firstWhere((j) => j.id == id);
    } catch (_) {
      return null;
    }
  }

  static void removeJob(String jobId) {
    jobs.removeWhere((j) => j.id == jobId);
    jobApplicants.remove(jobId);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ỨNG TUYỂN
  // ─────────────────────────────────────────────────────────────────────────

  static bool applyForJob(String jobId, String studentEmail, Job job) {
    jobApplicants.putIfAbsent(jobId, () => []);
    if (jobApplicants[jobId]!.contains(studentEmail)) return false;

    jobApplicants[jobId]!.add(studentEmail);

    studentApplications.putIfAbsent(studentEmail, () => []);
    if (!studentApplications[studentEmail]!.any((j) => j.id == job.id)) {
      studentApplications[studentEmail]!.add(job);
    }
    return true;
  }

  static List<Job> getAppliedJobs(String studentEmail) =>
      studentApplications[studentEmail] ?? [];

  static int getApplicantCount(String jobId) =>
      jobApplicants[jobId]?.length ?? 0;

  static bool hasApplied(String jobId, String studentEmail) =>
      jobApplicants[jobId]?.contains(studentEmail) ?? false;

  static List<String> getJobApplicants(String jobId) =>
      jobApplicants[jobId] ?? [];

  // ─────────────────────────────────────────────────────────────────────────
  // CHAT
  // ─────────────────────────────────────────────────────────────────────────

  static String getOrCreateConversationId(
      String user1, String user2, String jobTitle) {
    for (var c in conversations) {
      if ((c['participant1'] == user1 && c['participant2'] == user2) ||
          (c['participant1'] == user2 && c['participant2'] == user1)) {
        return c['id'] as String;
      }
    }
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    conversations.add({
      'id': id,
      'participant1': user1,
      'participant2': user2,
      'jobTitle': jobTitle,
      'createdAt': DateTime.now(),
    });
    return id;
  }

  static List<Map<String, dynamic>> getMessages(String conversationId) =>
      messages[conversationId] ?? [];

  static void addMessage(String conversationId, Map<String, dynamic> msg) {
    messages.putIfAbsent(conversationId, () => []);
    messages[conversationId]!.add(msg);
  }

  static List<Map<String, dynamic>> getConversationsForUser(String email) =>
      conversations
          .where((c) =>
              c['participant1'] == email || c['participant2'] == email)
          .toList();
}