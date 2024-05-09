import 'package:equatable/equatable.dart';

class AddNodeConfigState extends Equatable{
  @override
  List<Object> get props => [];
}

class AddNodeConfigInitState extends AddNodeConfigState {}

class AddNodeConfigLoadingState extends AddNodeConfigState{}

class AddNodeConfigSuccessState extends AddNodeConfigState{}

class AddNodeConfigFailState extends AddNodeConfigState{
  final String message;
  AddNodeConfigFailState({required this.message});
}