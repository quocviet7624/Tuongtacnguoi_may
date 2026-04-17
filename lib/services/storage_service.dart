import 'dart:convert';
import 'dart:html' as html;
import '../models/user_model.dart';
import '../models/job_model.dart';

class StorageService {
  // Dùng localStorage thay vì SharedPreferences để đảm bảo lưu trữ bền vững trên web
  static Future<void> init() async {
    print('✅ [StorageService] Initialized (using localStorage)');
  }

  static void _setString(String key, String value) {
    html.window.localStorage[key] = value;
  }

  static String? _getString(String key) {
    return html.window.localStorage[key];
  }

  static void _remove(String key) {
    html.window.localStorage.remove(key);
  }

  // ─── USERS ───────────────────────────────────────────────────────────────
  static List<AppUser> loadUsers() {
    final raw = _getString('users');
    if (raw == null || raw.isEmpty) {
      print('⚠️ [StorageService] No users found, returning empty list');
      return [];
    }
    try {
      final List<dynamic> list = jsonDecode(raw);
      final users = list.map((e) => AppUser.fromJson(e as Map<String, dynamic>)).toList();
      print('✅ [StorageService] Loaded ${users.length} users');
      return users;
    } catch (e, stack) {
      print('❌ [StorageService] Error loading users: $e\n$stack');
      return [];
    }
  }

  static Future<void> saveUsers(List<AppUser> users) async {
    try {
      final encoded = jsonEncode(users.map((u) => u.toJson()).toList());
      _setString('users', encoded);
      print('✅ [StorageService] Saved ${users.length} users, data length: ${encoded.length}');
    } catch (e, stack) {
      print('❌ [StorageService] Error saving users: $e\n$stack');
      rethrow;
    }
  }

  // ─── CURRENT USER ────────────────────────────────────────────────────────
  static AppUser? loadCurrentUser() {
    final raw = _getString('currentUser');
    if (raw == null || raw.isEmpty) return null;
    try {
      final user = AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      print('✅ [StorageService] Loaded current user: ${user.email}');
      return user;
    } catch (e) {
      print('❌ [StorageService] Error loading current user: $e');
      return null;
    }
  }

  static Future<void> saveCurrentUser(AppUser? user) async {
    try {
      if (user == null) {
        _remove('currentUser');
        print('✅ [StorageService] Removed current user');
      } else {
        final encoded = jsonEncode(user.toJson());
        _setString('currentUser', encoded);
        print('✅ [StorageService] Saved current user: ${user.email}');
      }
    } catch (e) {
      print('❌ [StorageService] Error saving current user: $e');
      rethrow;
    }
  }

  // ─── JOBS ────────────────────────────────────────────────────────────────
  static List<Job> loadJobs() {
    final raw = _getString('jobs');
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => Job.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('❌ [StorageService] Error loading jobs: $e');
      return [];
    }
  }

  static Future<void> saveJobs(List<Job> jobs) async {
    try {
      final encoded = jsonEncode(jobs.map((j) => j.toJson()).toList());
      _setString('jobs', encoded);
      print('✅ [StorageService] Saved ${jobs.length} jobs');
    } catch (e) {
      print('❌ [StorageService] Error saving jobs: $e');
      rethrow;
    }
  }

  // ─── JOB APPLICANTS ──────────────────────────────────────────────────────
  static Map<String, List<String>> loadJobApplicants() {
    final raw = _getString('jobApplicants');
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, List<String>.from(v as List)));
    } catch (e) {
      print('❌ [StorageService] Error loading applicants: $e');
      return {};
    }
  }

  static Future<void> saveJobApplicants(Map<String, List<String>> data) async {
    try {
      _setString('jobApplicants', jsonEncode(data));
    } catch (e) {
      print('❌ [StorageService] Error saving applicants: $e');
      rethrow;
    }
  }

  // ─── STUDENT APPLICATIONS ────────────────────────────────────────────────
  static Map<String, List<String>> loadStudentApplications() {
    final raw = _getString('studentApplications');
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, List<String>.from(v as List)));
    } catch (e) {
      print('❌ [StorageService] Error loading student apps: $e');
      return {};
    }
  }

  static Future<void> saveStudentApplications(Map<String, List<String>> data) async {
    try {
      _setString('studentApplications', jsonEncode(data));
    } catch (e) {
      print('❌ [StorageService] Error saving student apps: $e');
      rethrow;
    }
  }

  static Future<void> clearAll() async {
    html.window.localStorage.clear();
  }
}