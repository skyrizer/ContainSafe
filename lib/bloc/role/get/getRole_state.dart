import 'package:containsafe/model/node/node.dart';
import 'package:equatable/equatable.dart';

import '../../../model/role/role.dart';

class GetAllRoleState extends Equatable {
  const GetAllRoleState();
  @override
  List<Object> get props => [];
}

class GetAllRoleInitial extends GetAllRoleState { }

class GetAllRoleLoading extends GetAllRoleState { }

class GetAllRoleLoaded extends GetAllRoleState {
  final List<Role> roleList;
  const GetAllRoleLoaded({required this.roleList});
}

class GetAllRoleError extends GetAllRoleState {
  final String? error;
  const GetAllRoleError({required this.error});
}

class GetAllRoleEmpty extends GetAllRoleState {}