import 'package:containsafe/model/node/node.dart';
import 'package:equatable/equatable.dart';

import '../../../model/permission/permission.dart';
import '../../../model/role/role.dart';

class GetAllPermissionState extends Equatable {
  const GetAllPermissionState();
  @override
  List<Object> get props => [];
}

class GetAllPermissionInitial extends GetAllPermissionState { }

class GetAllPermissionLoading extends GetAllPermissionState { }

class GetAllPermissionLoaded extends GetAllPermissionState {
  final List<Permission> permissionList;
  const GetAllPermissionLoaded({required this.permissionList});
}

class GetAllPermissionError extends GetAllPermissionState {
  final String? error;
  const GetAllPermissionError({required this.error});
}

class GGetAllPermissionEmpty extends GetAllPermissionState {}