import 'package:equatable/equatable.dart';

class AddNodeServiceState extends Equatable{
  @override
  List<Object> get props => [];
}

class AddNodeServiceInitState extends AddNodeServiceState {}

class AddNodeServiceLoadingState extends AddNodeServiceState{}

class AddNodeServiceSuccessState extends AddNodeServiceState{}

class AddNodeServiceFailState extends AddNodeServiceState{
  final String message;
  AddNodeServiceFailState({required this.message});
}