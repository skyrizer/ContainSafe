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
      apache: json['apache'],
      mysql: json['mysql'],
      tomcat: json['tomcat'],
      docker: json['docker']
    );
  }
}