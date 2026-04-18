import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/job_model.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    assert(_prefs != null, 'StorageService.init() chưa được gọi!');
    return _prefs!;
  }

  // ── CURRENT USER (session) ───────────────────────────────────────────────

  static AppUser? loadCurrentUser() {
    final raw = prefs.getString('currentUser');
    if (raw == null) return null;
    try {
      return AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveCurrentUser(AppUser? user) async {
    if (user == null) {
      await prefs.remove('currentUser');
    } else {
      await prefs.setString('currentUser', jsonEncode(user.toJson()));
    }
  }

  // ── USERS ────────────────────────────────────────────────────────────────

  static List<AppUser> loadUsers() {
    final raw = prefs.getString('users');
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => AppUser.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveUsers(List<AppUser> users) async {
    await prefs.setString('users', jsonEncode(users.map((u) => u.toJson()).toList()));
  }

  // ── JOBS ─────────────────────────────────────────────────────────────────

  static List<Job> loadJobs() {
    final raw = prefs.getString('jobs');
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => Job.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveJobs(List<Job> jobs) async {
    await prefs.setString('jobs', jsonEncode(jobs.map((j) => j.toJson()).toList()));
  }

  // ── JOB APPLICANTS ───────────────────────────────────────────────────────

  static Map<String, List<String>> loadJobApplicants() {
    final raw = prefs.getString('jobApplicants');
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, List<String>.from(v as List)));
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveJobApplicants(Map<String, List<String>> data) async {
    await prefs.setString('jobApplicants', jsonEncode(data));
  }

  // ── STUDENT APPLICATIONS ─────────────────────────────────────────────────

  static Map<String, List<String>> loadStudentApplications() {
    final raw = prefs.getString('studentApplications');
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, List<String>.from(v as List)));
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveStudentApplications(
      Map<String, List<String>> data) async {
    await prefs.setString('studentApplications', jsonEncode(data));
  }

  // ── MESSAGES ─────────────────────────────────────────────────────────────

  static Map<String, List<Map<String, dynamic>>> loadMessages() {
    final raw = prefs.getString('messages');
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(
            k,
            (v as List).map((e) => Map<String, dynamic>.from(e as Map)).toList(),
          ));
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveMessages(
      Map<String, List<Map<String, dynamic>>> data) async {
    await prefs.setString('messages', jsonEncode(data));
  }

  // ── CONVERSATIONS ────────────────────────────────────────────────────────

  static List<Map<String, dynamic>> loadConversations() {
    final raw = prefs.getString('conversations');
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveConversations(
      List<Map<String, dynamic>> data) async {
    await prefs.setString('conversations', jsonEncode(data));
  }

  // ── INTERVIEWS ───────────────────────────────────────────────────────────

  static List<Map<String, dynamic>> loadInterviews() {
    final raw = prefs.getString('interviews');
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveInterviews(
      List<Map<String, dynamic>> data) async {
    await prefs.setString('interviews', jsonEncode(data));
  }

  // ── CLEAR ALL ────────────────────────────────────────────────────────────

  static Future<void> clearAll() async => await prefs.clear();
}