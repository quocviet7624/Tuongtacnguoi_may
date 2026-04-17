import 'dart:convert';

class Job {
  final String id;
  final String title;
  final String company;
  final String salary;
  final String location;
  final String description;
  final String requirements;
  final String category;
  final String shift;
  final int quantity;
  final String employerEmail;
  final DateTime postedDate;
  String status;

  Job({
    String? id,
    required this.title,
    required this.company,
    required this.salary,
    required this.location,
    required this.description,
    required this.requirements,
    required this.category,
    required this.shift,
    required this.quantity,
    required this.employerEmail,
    DateTime? postedDate,
    this.status = 'Đang hiển thị',
  })  : id = id ??
            '${DateTime.now().millisecondsSinceEpoch}_${employerEmail.hashCode.abs()}',
        postedDate = postedDate ?? DateTime.now();

  // ✅ THÊM: Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'salary': salary,
      'location': location,
      'description': description,
      'requirements': requirements,
      'category': category,
      'shift': shift,
      'quantity': quantity,
      'employerEmail': employerEmail,
      'postedDate': postedDate.toIso8601String(),
      'status': status,
    };
  }

  // ✅ THÊM: Create from JSON
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      salary: json['salary'],
      location: json['location'],
      description: json['description'],
      requirements: json['requirements'],
      category: json['category'],
      shift: json['shift'],
      quantity: json['quantity'],
      employerEmail: json['employerEmail'],
      postedDate: DateTime.parse(json['postedDate']),
      status: json['status'] ?? 'Đang hiển thị',
    );
  }

  String get postedDateFormatted {
    final diff = DateTime.now().difference(postedDate).inDays;
    if (diff == 0) return 'Hôm nay';
    if (diff == 1) return 'Hôm qua';
    return '$diff ngày trước';
  }

  String get expiryDate {
    final e = postedDate.add(const Duration(days: 30));
    return '${e.day.toString().padLeft(2, '0')}/${e.month.toString().padLeft(2, '0')}/${e.year}';
  }
}