class ServiceStatus {
  final int id;
  final String name;
  final bool value;

  ServiceStatus({required this.id, required this.name, required this.value});

  factory ServiceStatus.fromJson(Map<String, dynamic> json) {
    return ServiceStatus(
      id: json['id'] ,
      name: json['name'] as String,
      value: json['value'] as bool,
    );
  }
}