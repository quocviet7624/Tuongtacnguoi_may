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

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    users.addAll(StorageService.loadUsers());
    jobs.addAll(StorageService.loadJobs());
    jobApplicants.addAll(StorageService.loadJobApplicants());
    final loadedStudentApps = StorageService.loadStudentApplications();
    studentApplications.addAll(loadedStudentApps);

    print('📦 [GlobalData] Init complete: ${users.length} users, ${jobs.length} jobs');
  }

  static Future<void> _saveUsers() async {
    await StorageService.saveUsers(users);
  }
  static Future<void> _saveJobs() async {
    await StorageService.saveJobs(jobs);
  }
  static Future<void> _saveApplicants() => StorageService.saveJobApplicants(jobApplicants);
  static Future<void> _saveStudentApps() => StorageService.saveStudentApplications(studentApplications);

  static AppUser? findUser(String email, String password) {
    try {
      return users.firstWhere((u) => u.email == email && u.password == password);
    } catch (_) {
      return null;
    }
  }

  static bool emailExists(String email) => users.any((u) => u.email == email);

  static Future<void> addUser(AppUser user) async {
    users.add(user);
    await _saveUsers();
    print('➕ [GlobalData] Added user: ${user.email} (${user.role.name})');
  }

  static Future<void> addJob(Job job) async {
    jobs.insert(0, job);
    await _saveJobs();
    print('➕ [GlobalData] Added job: ${job.title}');
  }

  static List<Job> getAllJobs() => List.from(jobs);
  static List<Job> getJobsByEmployer(String email) => jobs.where((j) => j.employerEmail == email).toList();

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
    await _saveJobs();
    await _saveApplicants();
  }

  static Future<bool> applyForJob(String jobId, String studentEmail) async {
    jobApplicants.putIfAbsent(jobId, () => []);
    if (jobApplicants[jobId]!.contains(studentEmail)) return false;

    jobApplicants[jobId]!.add(studentEmail);
    studentApplications.putIfAbsent(studentEmail, () => []);
    if (!studentApplications[studentEmail]!.contains(jobId)) {
      studentApplications[studentEmail]!.add(jobId);
    }

    await _saveApplicants();
    await _saveStudentApps();
    return true;
  }

  static List<Job> getAppliedJobs(String studentEmail) {
    final jobIds = studentApplications[studentEmail] ?? [];
    return jobIds.map((id) => getJobById(id)).where((job) => job != null).cast<Job>().toList();
  }

  static int getApplicantCount(String jobId) => jobApplicants[jobId]?.length ?? 0;
  static bool hasApplied(String jobId, String studentEmail) => jobApplicants[jobId]?.contains(studentEmail) ?? false;
  static List<String> getJobApplicants(String jobId) => jobApplicants[jobId] ?? [];

  static String getOrCreateConversationId(String user1, String user2, String jobTitle) {
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

  static List<Map<String, dynamic>> getMessages(String conversationId) => messages[conversationId] ?? [];
  static void addMessage(String conversationId, Map<String, dynamic> msg) {
    messages.putIfAbsent(conversationId, () => []);
    messages[conversationId]!.add(msg);
  }

  static List<Map<String, dynamic>> getConversationsForUser(String email) =>
      conversations.where((c) => c['participant1'] == email || c['participant2'] == email).toList();

  static Future<void> saveUsers() async => await _saveUsers();
}