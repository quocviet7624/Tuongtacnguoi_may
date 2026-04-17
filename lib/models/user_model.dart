import 'dart:io';

enum UserRole { sinhVien, nhaTuyenDung }

class AppUser {
  final String email;
  final String password;
  final UserRole role;

  // Thông tin chung
  String fullName;
  String phone;
  File? avatarFile;

  // Thông tin riêng cho Sinh Viên
  String? school;
  String? major;
  double? gpa;
  List<String>? skills;
  double? salaryMin;
  double? salaryMax;
  List<String>? availableTime;

  // Thông tin riêng cho Nhà Tuyển Dụng
  String? companyName;
  String? address;
  String? taxCode;
  String? representative;
  String? businessType;

  AppUser({
    required this.email,
    required this.password,
    required this.role,
    this.fullName = '',
    this.phone = '',
    this.avatarFile,
    this.school,
    this.major,
    this.gpa,
    this.skills,
    this.salaryMin,
    this.salaryMax,
    this.availableTime,
    this.companyName,
    this.address,
    this.taxCode,
    this.representative,
    this.businessType,
  });
}