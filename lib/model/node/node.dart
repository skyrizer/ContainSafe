

class Node {
  int? id;
  String hostname;
  String ipAddress;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? error;
  bool? isConnected;


  Node({
    required this.id,
    required this.hostname,
    required this.ipAddress,
    required this.createdAt,
    required this.updatedAt,
    required this.error,
    this.isConnected = false, // Default connection status is false

  });

  Node.edit({
    required this.id,
    required this.hostname,
    required this.ipAddress,
  });

  Node.test({
    required this.hostname,
    required this.ipAddress,
    this.isConnected = false,
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