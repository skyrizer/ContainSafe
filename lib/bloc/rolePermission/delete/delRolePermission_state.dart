import 'package:equatable/equatable.dart';

class DeleteRolePermissionState extends Equatable{
  @override
  List<Object> get props => [];
}

// Delete Node Access
class DeleteRolePermissionInitState extends DeleteRolePermissionState {}

class DeleteRolePermissionLoadingState extends DeleteRolePermissionState {}

class DeleteRolePermissionSuccessState extends DeleteRolePermissionState {}

class DeleteRolePermissionFailState extends DeleteRolePermissionState {
  final String message;
  DeleteRolePermissionFailState({required this.message});
}


