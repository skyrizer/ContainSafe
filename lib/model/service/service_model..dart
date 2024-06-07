class ServiceModel {
  final int id;
  final String name;
  String? error;

  ServiceModel({required this.id, required this.name, required error});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      error: json['error'] ?? '',
      id: json['id'] ,
      name: json['name'] as String,
    );
  }
}