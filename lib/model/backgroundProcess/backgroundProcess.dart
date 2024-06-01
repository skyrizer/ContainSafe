class BackgroundProcess {
  int? id;
  String? name;
  int? serviceId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? error;

  BackgroundProcess({
    required this.id,
    required this.name,
    required this.serviceId,
    required this.createdAt,
    required this.updatedAt,
    required this.error,
  });

  BackgroundProcess.edit({
    required this.id,
    required this.name,
    required this.serviceId,
  });

  factory BackgroundProcess.fromJson(Map<String, dynamic> json) {
    return BackgroundProcess(
      error: json['error'] ?? '',
      id: json['id'],
      name: json['name'],
      serviceId: json['service_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

}
