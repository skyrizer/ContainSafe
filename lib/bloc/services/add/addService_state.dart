import 'package:equatable/equatable.dart';

class AddServiceState extends Equatable{
  @override
  List<Object> get props => [];
}

class AddServiceInitState extends AddServiceState {}

class AddServiceLoadingState extends AddServiceState{}

class AddServiceSuccessState extends AddServiceState{}

class AddServiceFailState extends AddServiceState{
  final String message;
  AddServiceFailState({required this.message});
}