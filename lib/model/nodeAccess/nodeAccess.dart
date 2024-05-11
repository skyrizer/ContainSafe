

import '../config/config.dart';
import '../node/node.dart';
import '../role/role.dart';
import '../user/user.dart';

class NodeAccess {
  int id;
  int roleId;
  int userId;
  int nodeId;
  DateTime createdAt;
  DateTime updatedAt;
  String error;
  Role role;
  Node node;
  User user;

  NodeAccess({
    required this.id,
    required this.nodeId,
    required this.userId,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
    required this.error,
    required this.role,
    required this.node,
    required this.user,

  });

  factory NodeAccess.fromJson(Map<String, dynamic> json) {
    return NodeAccess(
      error: json['error'] ?? '',
      id: json['id'] ?? '',
      nodeId: json['node_id'] ?? '',
      userId: json['user_id'] ?? '',
      roleId: json['role_id'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      role: Role.fromJson(json['role']),
      node: Node.fromJson(json['node']),
      user: User.fromJson(json['user']),

    );
  }


}