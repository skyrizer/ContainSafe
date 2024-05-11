
class Role {
  int? id;
  String? role;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? error;

  Role({
    required this.id,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.error,
  });

  Role.edit({
    required this.id,
    required this.role,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      error: json['error'] ?? '',
      id: json['id'],
      role: json['role'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

}
