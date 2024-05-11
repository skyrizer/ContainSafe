import 'package:equatable/equatable.dart';

class AddPermissionState extends Equatable{
  @override
  List<Object> get props => [];
}

class AddPermissionInitState extends AddPermissionState {}

class AddPermissionLoadingState extends AddPermissionState{}

class AddPermissionSuccessState extends AddPermissionState{}

class AddPermissionFailState extends AddPermissionState{
  final String message;
  AddPermissionFailState({required this.message});
}