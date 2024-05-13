import 'package:containsafe/model/rolePermission/rolePermission.dart';
import 'package:equatable/equatable.dart';
import '../../../model/nodeConfig/nodeConfig.dart';

class GetAllRolePermissionState extends Equatable {
  const  GetAllRolePermissionState();
  @override
  List<Object> get props => [];
}

class  GetAllRolePermissionInitial extends  GetAllRolePermissionState { }

class  GetAllRolePermissionLoading extends  GetAllRolePermissionState { }

class  GetAllRolePermissionLoaded extends  GetAllRolePermissionState {
  final List<RolePermission> rolePermissionList;
  const  GetAllRolePermissionLoaded({required this.rolePermissionList});
}

class  GetAllRolePermissionError extends  GetAllRolePermissionState {
  final String? error;
  const  GetAllRolePermissionError({required this.error});
}

class  GetAllRolePermissionEmpty extends  GetAllRolePermissionState {}