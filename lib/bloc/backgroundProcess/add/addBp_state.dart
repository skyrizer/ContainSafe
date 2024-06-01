import 'package:equatable/equatable.dart';

class AddBpState extends Equatable{
  @override
  List<Object> get props => [];
}

class AddBpInitState extends AddBpState {}

class AddBpLoadingState extends AddBpState{}

class AddBpSuccessState extends AddBpState{}

class AddBpFailState extends AddBpState{
  final String message;
  AddBpFailState({required this.message});
}