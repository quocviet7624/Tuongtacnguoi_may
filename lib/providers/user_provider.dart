import 'package:flutter/material.dart';
import 'dart:io';
import '../models/user_model.dart';
import '../models/global_data.dart';
import '../services/storage_service.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _currentUser;

  UserProvider() {
    _restoreSession();
  }

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isEmployer =>
      _currentUser?.role == UserRole.nhaTuyenDung;
  bool get isStudent =>
      _currentUser?.role == UserRole.sinhVien;

  // ─── RESTORE SESSION ──────────────────────────────────────────
  void _restoreSession() {
    final saved = StorageService.loadCurrentUser();
    if (saved == null) return;
    // Lấy bản live từ GlobalData (có thể đã update)
    final live = GlobalData.users
        .cast<AppUser?>()
        .firstWhere((u) => u?.email == saved.email,
            orElse: () => null);
    _currentUser = live ?? saved;
  }

  // ─── ĐĂNG NHẬP ────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    final user = GlobalData.findUser(email, password);
    if (user == null) return false;
    _currentUser = user;
    await StorageService.saveCurrentUser(user);
    notifyListeners();
    return true;
  }

  // ─── ĐĂNG XUẤT ────────────────────────────────────────────────
  Future<void> logout() async {
    _currentUser = null;
    await StorageService.saveCurrentUser(null);
    notifyListeners();
  }

  // ─── ĐĂNG KÝ SINH VIÊN bước 1 ────────────────────────────────
  Future<void> createStudentAccount({
    required String email,
    required String password,
    required String phone,
  }) async {
    final user = AppUser(
      email: email,
      password: password,
      role: UserRole.sinhVien,
      phone: phone,
    );
    await GlobalData.addUser(user);
    _currentUser = user;
    await StorageService.saveCurrentUser(user);
    notifyListeners();
  }

  // ─── ĐĂNG KÝ SINH VIÊN bước 2 ────────────────────────────────
  Future<void> updateStudentInfo({
    required String fullName,
    required String school,
    required String major,
    required double gpa,
  }) async {
    if (_currentUser == null) return;
    _currentUser!.fullName = fullName;
    _currentUser!.school = school;
    _currentUser!.major = major;
    _currentUser!.gpa = gpa;
    await _persist();
  }

  // ─── ĐĂNG KÝ SINH VIÊN bước 3 ────────────────────────────────
  Future<void> updateFinalStep({
    required List<String> newSkills,
    File? newAvatar,
    double? salaryMin,
    double? salaryMax,
    List<String>? availableTime,
  }) async {
    if (_currentUser == null) return;
    _currentUser!.skills = newSkills;
    if (newAvatar != null) _currentUser!.avatarPath = newAvatar.path;
    _currentUser!.salaryMin = salaryMin;
    _currentUser!.salaryMax = salaryMax;
    _currentUser!.availableTime = availableTime;
    await _persist();
  }

  // ─── ĐĂNG KÝ NHÀ TUYỂN DỤNG ──────────────────────────────────
  Future<void> createEmployerAccount({
    required String email,
    required String password,
    required String phone,
    required String companyName,
    required String address,
    required String taxCode,
    required String representative,
    required String businessType,
  }) async {
    final user = AppUser(
      email: email,
      password: password,
      role: UserRole.nhaTuyenDung,
      phone: phone,
      fullName: representative,
      companyName: companyName,
      address: address,
      taxCode: taxCode,
      representative: representative,
      businessType: businessType,
    );
    await GlobalData.addUser(user);
    _currentUser = user;
    await StorageService.saveCurrentUser(user);
    notifyListeners();
  }

  // ─── CẬP NHẬT HỒ SƠ ──────────────────────────────────────────
  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? school,
    String? major,
    double? gpa,
    List<String>? skills,
    File? avatarFile,
    String? companyName,
    String? address,
    String? taxCode,
    String? representative,
    String? businessType,
  }) async {
    if (_currentUser == null) return;
    if (fullName != null) _currentUser!.fullName = fullName;
    if (phone != null) _currentUser!.phone = phone;
    if (school != null) _currentUser!.school = school;
    if (major != null) _currentUser!.major = major;
    if (gpa != null) _currentUser!.gpa = gpa;
    if (skills != null) _currentUser!.skills = skills;
    if (avatarFile != null) _currentUser!.avatarPath = avatarFile.path;
    if (companyName != null) _currentUser!.companyName = companyName;
    if (address != null) _currentUser!.address = address;
    if (taxCode != null) _currentUser!.taxCode = taxCode;
    if (representative != null) _currentUser!.representative = representative;
    if (businessType != null) _currentUser!.businessType = businessType;
    await _persist();
  }

  // ─── PERSIST: lưu cả currentUser lẫn list users ───────────────
  Future<void> _persist() async {
    if (_currentUser == null) return;
    // Cập nhật trong GlobalData.users
    final idx = GlobalData.users
        .indexWhere((u) => u.email == _currentUser!.email);
    if (idx != -1) {
      GlobalData.users[idx] = _currentUser!;
    }
    await StorageService.saveUsers(GlobalData.users);
    await StorageService.saveCurrentUser(_currentUser);
    notifyListeners();
  }
}