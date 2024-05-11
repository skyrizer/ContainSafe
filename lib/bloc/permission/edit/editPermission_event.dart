import 'package:equatable/equatable.dart';
import '../../../model/permission/permission.dart';
import '../../../model/role/role.dart';

class EditPermissionEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class UpdatePermissionButtonPressed extends EditPermissionEvent {
  Permission permission;
  UpdatePermissionButtonPressed({ required this.permission });
}