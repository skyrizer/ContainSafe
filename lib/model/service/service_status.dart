class ServiceStatus {
  final bool apache;
  final bool mysql;
  final bool tomcat;
  final bool docker;

  ServiceStatus({
    required this.apache,
    required this.mysql,
    required this.tomcat,
    required this.docker,

  });

  factory ServiceStatus.fromJson(Map<String, dynamic> json) {
    return ServiceStatus(
      apache: json['Apache'],
      mysql: json['MySQL'],
      tomcat: json['Tomcat'],
      docker: json['Docker'] ?? false
    );
  }
}