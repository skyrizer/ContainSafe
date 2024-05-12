import 'package:equatable/equatable.dart';

class AddNodeAccessState extends Equatable{
  @override
  List<Object> get props => [];
}

class AddNodeAccessInitState extends AddNodeAccessState {}

class AddNodeAccessLoadingState extends AddNodeAccessState{}

class AddNodeAccessSuccessState extends AddNodeAccessState{}

class AddNodeAccessFailState extends AddNodeAccessState{
  final String message;
  AddNodeAccessFailState({required this.message});
}