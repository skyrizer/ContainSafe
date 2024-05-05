

class ContainerModel {
  String? id;
  String? name;
  String? image;
  String? status;
  String? port;
  String? diskLimit;
  String? memLimit;
  String? netLimit;
  String? cpuLimit;
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
      error: json['error'] ?? '',
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'] ?? '',
      port: json['port'],
      diskLimit: json['disk_limit'],
      memLimit: json['mem_limit'],
      netLimit: json['net_limit'],
      cpuLimit: json['cpu_limit'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'hostname': hostname,
  //     'ip_address': ipAddress,
  //   };
  // }
}