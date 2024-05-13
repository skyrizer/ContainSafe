

import '../config/config.dart';
import '../node/node.dart';

class NodeConfig {
  final int nodeId;
  final int configId;
  final int value;
  final DateTime createdAt;
  final DateTime updatedAt;
  late String error;
  final Config config;
  final Node node;

  NodeConfig({
    required this.nodeId,
    required this.configId,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
    required this.error,
    required this.config,
    required this.node,
  });

  factory NodeConfig.fromJson(Map<String, dynamic> json) {
    return NodeConfig(
      error: json['error'] ?? '',
      nodeId: json['node_id'] ?? '',
      configId: json['config_id'] ?? '',
      value: json['value'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      config: Config.fromJson(json['config']),
      node: Node.fromJson(json['node']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'node_id': nodeId,
      'config_id': configId,
      'value': value
    };
  }
}