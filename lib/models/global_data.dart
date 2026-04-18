import 'job_model.dart';
import 'user_model.dart';
import '../services/storage_service.dart';

class GlobalData {
  GlobalData._();

  static final List<AppUser> users = [];
  static final List<Job> jobs = [];
  static final Map<String, List<String>> jobApplicants = {};
  static final Map<String, List<String>> studentApplications = {};
  static final Map<String, List<Map<String, dynamic>>> messages = {};
  static final List<Map<String, dynamic>> conversations = [];
  static final List<Map<String, dynamic>> interviews = [];

  static bool _initialized = false;

  // ─────────────────────────────────────────────────────────────
  // INIT
  // ─────────────────────────────────────────────────────────────
  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    users..clear()..addAll(StorageService.loadUsers());
    jobs..clear()..addAll(StorageService.loadJobs());
    jobApplicants..clear()..addAll(StorageService.loadJobApplicants());
    studentApplications..clear()..addAll(StorageService.loadStudentApplications());
    messages..clear()..addAll(StorageService.loadMessages());
    conversations..clear()..addAll(StorageService.loadConversations());
    interviews..clear()..addAll(StorageService.loadInterviews());

    await _ensureDemoAccounts();
  }

  // ─────────────────────────────────────────────────────────────
  // SEED: chỉ tạo tài khoản demo nếu chưa tồn tại
  // Không tạo job hay interview mẫu — dùng dữ liệu thật từ người dùng
  // ─────────────────────────────────────────────────────────────
  static Future<void> _ensureDemoAccounts() async {
    bool changed = false;

    if (!emailExists('sv@gmail.com')) {
      users.add(AppUser(
        email: 'sv@gmail.com',
        password: '123456',
        role: UserRole.sinhVien,
        fullName: 'Nguyễn Văn An',
        phone: '0912345678',
        school: 'Đại học Bách khoa Đà Nẵng',
        major: 'Công nghệ thông tin',
        gpa: 3.5,
        skills: ['Flutter', 'Dart', 'Tiếng Anh', 'Figma'],
        salaryMin: 5000000,
        salaryMax: 10000000,
      ));
      changed = true;
    }

    if (!emailExists('ntd@gmail.com')) {
      users.add(AppUser(
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
      ));
      changed = true;
    }

    if (changed) {
      await StorageService.saveUsers(users);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // USER
  // ─────────────────────────────────────────────────────────────

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

  static Future<void> addUser(AppUser user) async {
    users.add(user);
    await StorageService.saveUsers(users);
  }

  static Future<void> updateUser(AppUser updated) async {
    final idx = users.indexWhere((u) => u.email == updated.email);
    if (idx != -1) {
      users[idx] = updated;
      await StorageService.saveUsers(users);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // JOB
  // ─────────────────────────────────────────────────────────────

  static Future<void> addJob(Job job) async {
    jobs.insert(0, job);
    await StorageService.saveJobs(jobs);
  }

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

  static Future<void> removeJob(String jobId) async {
    jobs.removeWhere((j) => j.id == jobId);
    jobApplicants.remove(jobId);
    await StorageService.saveJobs(jobs);
    await StorageService.saveJobApplicants(jobApplicants);
  }

  // ─────────────────────────────────────────────────────────────
  // ỨNG TUYỂN
  // ─────────────────────────────────────────────────────────────

  static Future<bool> applyForJob(String jobId, String studentEmail) async {
    jobApplicants.putIfAbsent(jobId, () => []);
    if (jobApplicants[jobId]!.contains(studentEmail)) return false;

    jobApplicants[jobId]!.add(studentEmail);
    studentApplications.putIfAbsent(studentEmail, () => []);
    if (!studentApplications[studentEmail]!.contains(jobId)) {
      studentApplications[studentEmail]!.add(jobId);
    }

    await StorageService.saveJobApplicants(jobApplicants);
    await StorageService.saveStudentApplications(studentApplications);
    return true;
  }

  static List<Job> getAppliedJobs(String studentEmail) {
    final ids = studentApplications[studentEmail] ?? [];
    return ids.map((id) => getJobById(id)).whereType<Job>().toList();
  }

  static int getApplicantCount(String jobId) =>
      jobApplicants[jobId]?.length ?? 0;

  static bool hasApplied(String jobId, String studentEmail) =>
      jobApplicants[jobId]?.contains(studentEmail) ?? false;

  static List<String> getJobApplicants(String jobId) =>
      jobApplicants[jobId] ?? [];

  // ─────────────────────────────────────────────────────────────
  // INTERVIEW
  // ─────────────────────────────────────────────────────────────

  static Future<void> addInterview(Map<String, dynamic> interview) async {
    interviews.add(interview);
    await StorageService.saveInterviews(interviews);
  }

  static Future<void> saveInterviews() async {
    await StorageService.saveInterviews(interviews);
  }

  static List<Map<String, dynamic>> getInterviewsForEmployer(String email) =>
      interviews.where((i) => i['employerEmail'] == email).toList();

  static List<Map<String, dynamic>> getInterviewsForStudent(String email) =>
      interviews.where((i) => i['candidateEmail'] == email).toList();

  // ─────────────────────────────────────────────────────────────
  // CHAT
  // ─────────────────────────────────────────────────────────────

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
      'createdAt': DateTime.now().toIso8601String(),
    });
    StorageService.saveConversations(conversations);
    return id;
  }

  static List<Map<String, dynamic>> getMessages(String convId) =>
      messages[convId] ?? [];

  static Future<void> addMessage(
      String convId, Map<String, dynamic> msg) async {
    messages.putIfAbsent(convId, () => []);
    messages[convId]!.add(msg);
    await StorageService.saveMessages(messages);
  }

  static List<Map<String, dynamic>> getConversationsForUser(String email) =>
      conversations
          .where((c) =>
              c['participant1'] == email || c['participant2'] == email)
          .toList();
}