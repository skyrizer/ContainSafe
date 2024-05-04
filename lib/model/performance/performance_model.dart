class Performance {
  late String containerName;
  late List<Map<String, dynamic>> diskUsage;
  late List<Map<String, dynamic>> cpuUsage;
  late List<Map<String, dynamic>> memoryUsage;
  late List<Map<String, dynamic>> networkUsage;
  late String error;

  Performance({
    required this.containerName,
    required this.diskUsage,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.networkUsage,
    required this.error,
  });

  factory Performance.fromJson(String containerName, Map<String, dynamic> json) {
    return Performance(
      containerName: containerName,
      error: json["error"] ?? "",
      diskUsage: _parseUsage(json['diskUsage']),
      cpuUsage: _parseUsage(json['cpuUsage']),
      memoryUsage: _parseUsage(json['memoryUsage']),
      networkUsage: _parseUsage(json['networkUsage']),
    );
  }

  static List<Map<String, dynamic>> _parseUsage(Map<String, dynamic>? usage) {
    return usage != null ? [usage] : [];
  }
}
