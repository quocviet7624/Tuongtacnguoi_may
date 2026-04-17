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