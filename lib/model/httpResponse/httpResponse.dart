class HttpResponse {
  final int id;
  final String url;
  final int statusCode;
  final String method;
  final String ipAddress;
  final DateTime createdAt;
  final DateTime updatedAt;
  late String error;

  HttpResponse({
    required this.id,
    required this.url,
    required this.statusCode,
    required this.method,
    required this.ipAddress,
    required this.createdAt,
    required this.updatedAt,
    required this.error,
  });

  factory HttpResponse.fromJson(Map<String, dynamic> json) {
    return HttpResponse(
      error: json['error'] ?? '',
      id: json['id'],
      url: json['url'],
      statusCode: json['status_code'],
      method: json['method'],
      ipAddress: json['ip_address'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'hostname': hostname,
  //     'ip_address': ipAddress,
  //   };
  // }
}