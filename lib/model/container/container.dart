

class ContainerModel {
  String? id;
  String? name;
  String? image;
  String? status;
  String? port;
  int? diskLimit;
  int? memLimit;
  int? netLimit;
  int? cpuLimit;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? error;

  ContainerModel({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.port,
    required this.diskLimit,
    required this.memLimit,
    required this.netLimit,
    required this.cpuLimit,
    required this.createdAt,
    required this.updatedAt,
    required this.error,
  });

  ContainerModel.edit({
    required this.id,
    required this.diskLimit,
    required this.memLimit,
    required this.netLimit,
    required this.cpuLimit,
  });

  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel(
      error: json['error'] ?? '', // Assigning empty string as default value if error is null
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      port: json['port'] ?? '',
      diskLimit: json['disk_limit'] ?? 0, // Assigning 0 as default value if disk_limit is null
      memLimit: json['mem_limit'] ?? 0,
      netLimit: json['net_limit'] ?? 0,
      cpuLimit: json['cpu_limit'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(), // Assigning current date/time as default value if created_at is null
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'hostname': hostname,
  //     'ip_address': ipAddress,
  //   };
  // }
}