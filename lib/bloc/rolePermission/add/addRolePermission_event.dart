import 'package:equatable/equatable.dart';


class AddRolePermissionEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartRegister extends AddRolePermissionEvents {}

class AddRolePermissionButtonPressed extends AddRolePermissionEvents {

  final int roleId;
  final int permissionId;


  AddRolePermissionButtonPressed({
    required this.roleId,
    required this.permissionId,
  });

}

