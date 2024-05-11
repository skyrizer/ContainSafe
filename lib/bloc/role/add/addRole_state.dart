import 'package:equatable/equatable.dart';

class AddRoleState extends Equatable{
  @override
  List<Object> get props => [];
}

class AddRoleInitState extends AddRoleState {}

class AddRoleLoadingState extends AddRoleState{}

class AddRoleSuccessState extends AddRoleState{}

class AddRoleFailState extends AddRoleState{
  final String message;
  AddRoleFailState({required this.message});
}