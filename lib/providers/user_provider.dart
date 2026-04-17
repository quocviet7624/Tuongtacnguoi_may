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
  bool get isEmployer => _currentUser?.role == UserRole.nhaTuyenDung;
  bool get isStudent => _currentUser?.role == UserRole.sinhVien;

  void _restoreSession() {
    final saved = StorageService.loadCurrentUser();
    if (saved == null) return;

    final liveUser = GlobalData.users.cast<AppUser?>().firstWhere(
          (u) => u?.email == saved.email,
          orElse: () => null,
        );

    _currentUser = liveUser ?? saved;
    print('🔐 [UserProvider] Restored: ${_currentUser?.email} (${_currentUser?.role.name})');
  }

  Future<bool> login(String email, String password) async {
    final user = GlobalData.findUser(email, password);
    if (user != null) {
      _currentUser = user;
      await StorageService.saveCurrentUser(user);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    await StorageService.saveCurrentUser(null);
    notifyListeners();
  }

  Future<void> createStudentAccount({
    required String email,
    required String password,
    required String phone,
  }) async {
    final newUser = AppUser(
      email: email,
      password: password,
      role: UserRole.sinhVien,
      phone: phone,
    );
    await GlobalData.addUser(newUser);
    _currentUser = newUser;
    await StorageService.saveCurrentUser(newUser);
    notifyListeners();
    print('✅ [UserProvider] Created student: $email');
  }

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
    notifyListeners();
  }

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
    notifyListeners();
  }

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
    await GlobalData.addUser(newUser);
    _currentUser = newUser;
    await StorageService.saveCurrentUser(newUser);
    notifyListeners();
    print('✅ [UserProvider] Created employer: $email');
  }

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
    notifyListeners();
  }

  Future<void> _persist() async {
    await StorageService.saveCurrentUser(_currentUser);
    await StorageService.saveUsers(GlobalData.users);
    print('💾 [UserProvider] Persisted user: ${_currentUser?.email}');
  }

  Future<void> saveUsers() => _persist();
}