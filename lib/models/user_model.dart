import 'dart:io';

enum UserRole { sinhVien, nhaTuyenDung }

class AppUser {
  final String email;
  String password;
  final UserRole role;

  String? fullName;
  String? phone;

  // Sinh viên
  String? school;
  String? major;
  double? gpa;
  List<String>? skills;
  String? avatarPath;
  double? salaryMin;
  double? salaryMax;
  List<String>? availableTime;

  // Nhà tuyển dụng
  String? companyName;
  String? address;
  String? taxCode;
  String? representative;
  String? businessType;

  AppUser({
    required this.email,
    required this.password,
    required this.role,
    this.fullName,
    this.phone,
    this.school,
    this.major,
    this.gpa,
    this.skills,
    this.avatarPath,
    this.salaryMin,
    this.salaryMax,
    this.availableTime,
    this.companyName,
    this.address,
    this.taxCode,
    this.representative,
    this.businessType,
  });

  // ✅ Getter: chuyển avatarPath (String?) → File? để các screen dùng trực tiếp
  File? get avatarFile =>
      (avatarPath != null && avatarPath!.isNotEmpty) ? File(avatarPath!) : null;

  // ✅ Helper: tên hiển thị không bao giờ null
  String get displayName =>
      (fullName != null && fullName!.isNotEmpty) ? fullName! : email;

  // ✅ Helper: số điện thoại hiển thị không bao giờ null
  String get displayPhone =>
      (phone != null && phone!.isNotEmpty) ? phone! : 'Chưa cập nhật';

  // ─── Serialization ──────────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'role': role.name,
        'fullName': fullName,
        'phone': phone,
        'school': school,
        'major': major,
        'gpa': gpa,
        'skills': skills,
        'avatarPath': avatarPath,
        'salaryMin': salaryMin,
        'salaryMax': salaryMax,
        'availableTime': availableTime,
        'companyName': companyName,
        'address': address,
        'taxCode': taxCode,
        'representative': representative,
        'businessType': businessType,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      email: json['email'] as String,
      password: json['password'] as String,
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.sinhVien,
      ),
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      school: json['school'] as String?,
      major: json['major'] as String?,
      gpa: (json['gpa'] as num?)?.toDouble(),
      skills: (json['skills'] as List?)?.cast<String>(),
      avatarPath: json['avatarPath'] as String?,
      salaryMin: (json['salaryMin'] as num?)?.toDouble(),
      salaryMax: (json['salaryMax'] as num?)?.toDouble(),
      availableTime: (json['availableTime'] as List?)?.cast<String>(),
      companyName: json['companyName'] as String?,
      address: json['address'] as String?,
      taxCode: json['taxCode'] as String?,
      representative: json['representative'] as String?,
      businessType: json['businessType'] as String?,
    );
  }
}