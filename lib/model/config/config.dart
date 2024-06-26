class Config {
  int? id;
  String? name;
  String? unit;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? error;

  Config({
    required this.id,
    required this.name,
    required this.unit,
    required this.createdAt,
    required this.updatedAt,
    required this.error,
  });

  Config.edit({
    required this.id,
    required this.name,
    required this.unit,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      error: json['error'] ?? '',
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit': unit,
    };
  }
}
