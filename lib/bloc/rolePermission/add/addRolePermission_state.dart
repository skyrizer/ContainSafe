import 'package:equatable/equatable.dart';

class AddRolePermissionState extends Equatable{
  @override
  List<Object> get props => [];
}

class AddRolePermissionInitState extends AddRolePermissionState {}

class AddRolePermissionLoadingState extends AddRolePermissionState{}

class AddRolePermissionSuccessState extends AddRolePermissionState{}

class AddRolePermissionFailState extends AddRolePermissionState{
  final String message;
  AddRolePermissionFailState({required this.message});
}