class PerformanceWS {
  final String containerId;
  final String containerName;
  final String cpuUsage;
  final String memUsage;
  final String memSize;
  final String netInput;
  final String netOutput;
  final String blockInput;
  final String blockOutput;
  final String pids;
  final DateTime timestamp;

  PerformanceWS({
    required this.containerId,
    required this.containerName,
    required this.cpuUsage,
    required this.memUsage,
    required this.memSize,
    required this.netInput,
    required this.netOutput,
    required this.blockInput,
    required this.blockOutput,
    required this.pids,
    required this.timestamp,

  });

  factory PerformanceWS.fromJson(Map<String, dynamic> json) {
    return PerformanceWS(
      containerId: json['CONTAINER ID'],
      containerName: json['NAME'],
      cpuUsage: json['CPU %'],
      memUsage: json['MEM USAGE'],
      memSize: json['MEM SIZE'],
      netInput: json['NET INPUT'],
      netOutput: json['NET OUTPUT'],
      blockInput: json['BLOCK INPUT'],
      blockOutput: json['BLOCK OUTPUT'],
      pids: json['PIDS'],
      timestamp: DateTime.parse(json['TIMESTAMP']),
    );
  }
}
