import 'package:equatable/equatable.dart';


class DeleteRolePermissionEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartDeleteRolePermission extends DeleteRolePermissionEvents {}

class DeleteRolePermissionButtonPressed extends DeleteRolePermissionEvents{
  final int roleId;
  final int permissionId;

  DeleteRolePermissionButtonPressed({
    required this.roleId,
    required this.permissionId,

  });

}