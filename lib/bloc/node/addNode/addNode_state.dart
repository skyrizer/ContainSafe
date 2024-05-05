import 'package:equatable/equatable.dart';

class AddNodeState extends Equatable{
  @override
  List<Object> get props => [];
}

class AddNodeInitState extends AddNodeState {}

class AddNodeLoadingState extends AddNodeState{}

class AddNodeSuccessState extends AddNodeState{}

class AddNodeFailState extends AddNodeState{
  final String message;
  AddNodeFailState({required this.message});
}