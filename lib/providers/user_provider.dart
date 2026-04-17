import 'package:flutter/material.dart';
import 'dart:io';
import '../models/user_model.dart';
import '../models/global_data.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _currentUser;

  /// Getter để các màn hình dùng: userProvider.currentUser
  AppUser? get currentUser => _currentUser;

  /// Kiểm tra đã đăng nhập chưa
  bool get isLoggedIn => _currentUser != null;

  /// Kiểm tra là nhà tuyển dụng không
  bool get isEmployer => _currentUser?.role == UserRole.nhaTuyenDung;

  /// Kiểm tra là sinh viên không
  bool get isStudent => _currentUser?.role == UserRole.sinhVien;

  // ──────────────────────────────────────────────────────────────────────────
  // ĐĂNG NHẬP / ĐĂNG XUẤT
  // ──────────────────────────────────────────────────────────────────────────

  /// Đăng nhập - trả về true nếu thành công
  bool login(String email, String password) {
    final user = GlobalData.findUser(email, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Đăng xuất
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // ĐĂNG KÝ SINH VIÊN
  // ──────────────────────────────────────────────────────────────────────────

  /// Bước 1: Tạo tài khoản sinh viên mới (email + pass + role)
  void createStudentAccount({
    required String email,
    required String password,
    required String phone,
  }) {
    final newUser = AppUser(
      email: email,
      password: password,
      role: UserRole.sinhVien,
      phone: phone,
    );
    GlobalData.addUser(newUser);
    _currentUser = newUser;
    notifyListeners();
  }

  /// Bước 2: Cập nhật thông tin học vấn sinh viên
  void updateStudentInfo({
    required String fullName,
    required String school,
    required String major,
    required double gpa,
  }) {
    if (_currentUser == null) return;
    _currentUser!.fullName = fullName;
    _currentUser!.school = school;
    _currentUser!.major = major;
    _currentUser!.gpa = gpa;
    notifyListeners();
  }

  /// Bước 3: Cập nhật kỹ năng + avatar (bước cuối đăng ký SV)
  void updateFinalStep({
    required List<String> newSkills,
    File? newAvatar,
    double? salaryMin,
    double? salaryMax,
    List<String>? availableTime,
  }) {
    if (_currentUser == null) return;
    _currentUser!.skills = newSkills;
    _currentUser!.avatarFile = newAvatar;
    _currentUser!.salaryMin = salaryMin;
    _currentUser!.salaryMax = salaryMax;
    _currentUser!.availableTime = availableTime;
    notifyListeners();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // ĐĂNG KÝ NHÀ TUYỂN DỤNG
  // ──────────────────────────────────────────────────────────────────────────

  /// Tạo tài khoản nhà tuyển dụng mới
  void createEmployerAccount({
    required String email,
    required String password,
    required String phone,
    required String companyName,
    required String address,
    required String taxCode,
    required String representative,
    required String businessType,
  }) {
    final newUser = AppUser(
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
    GlobalData.addUser(newUser);
    _currentUser = newUser;
    notifyListeners();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // CẬP NHẬT HỒ SƠ (dùng ở màn Chỉnh sửa hồ sơ)
  // ──────────────────────────────────────────────────────────────────────────

  void updateProfile({
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
  }) {
    if (_currentUser == null) return;
    if (fullName != null) _currentUser!.fullName = fullName;
    if (phone != null) _currentUser!.phone = phone;
    if (school != null) _currentUser!.school = school;
    if (major != null) _currentUser!.major = major;
    if (gpa != null) _currentUser!.gpa = gpa;
    if (skills != null) _currentUser!.skills = skills;
    if (avatarFile != null) _currentUser!.avatarFile = avatarFile;
    if (companyName != null) _currentUser!.companyName = companyName;
    if (address != null) _currentUser!.address = address;
    if (taxCode != null) _currentUser!.taxCode = taxCode;
    if (representative != null) _currentUser!.representative = representative;
    if (businessType != null) _currentUser!.businessType = businessType;
    notifyListeners();
  }
}