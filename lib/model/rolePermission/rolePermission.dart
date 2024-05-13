

import '../config/config.dart';
import '../node/node.dart';
import '../permission/permission.dart';
import '../role/role.dart';

class RolePermission {
  final int roleId;
  final int permissionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  late String error;
  final Role role;
  final Permission permission;

  RolePermission({
    required this.roleId,
    required this.permissionId,
    required this.createdAt,
    required this.updatedAt,
    required this.error,
    required this.role,
    required this.permission,
  });

  factory RolePermission.fromJson(Map<String, dynamic> json) {
    return RolePermission(
      error: json['error'] ?? '',
      roleId: json['role_id'] ?? '',
      permissionId: json['permission_id'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      role: Role.fromJson(json['role']),
      permission: Permission.fromJson(json['permission']),
    );
  }

}