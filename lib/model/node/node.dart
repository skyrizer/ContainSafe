class Node {
  final int id;
  final String hostname;
  final String ipAddress;
  final DateTime createdAt;
  final DateTime updatedAt;
  late String error;

  Node({
    required this.id,
    required this.hostname,
    required this.ipAddress,
    required this.createdAt,
    required this.updatedAt,
    required this.error,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      error: json['error'] ?? '',
      id: json['id'],
      hostname: json['hostname'],
      ipAddress: json['ip_address'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hostname': hostname,
      'ip_address': ipAddress,
    };
  }
}