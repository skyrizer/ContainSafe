

class Config {
  final int id;
  final String name;
  final String unit;
  final DateTime createdAt;
  final DateTime updatedAt;
  late String error;

  Config({
    required this.id,
    required this.name,
    required this.unit,
    required this.createdAt,
    required this.updatedAt,
    required this.error,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      error: json['error'] ?? '',
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit': unit,
    };
  }
}