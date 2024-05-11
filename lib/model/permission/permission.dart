
class Permission {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? error;

  Permission({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.error,
  });

  Permission.edit({
    required this.id,
    required this.name,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      error: json['error'] ?? '',
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

}
