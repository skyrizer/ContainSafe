import 'package:equatable/equatable.dart';

class DeleteNodeConfigState extends Equatable{
  @override
  List<Object> get props => [];
}

// Delete Node Access
class DeleteNodeConfigInitState extends DeleteNodeConfigState {}

class DeleteNodeConfigLoadingState extends DeleteNodeConfigState {}

class DeleteNodeConfigSuccessState extends DeleteNodeConfigState {}

class DeleteNodeConfigFailState extends DeleteNodeConfigState {
  final String message;
  DeleteNodeConfigFailState({required this.message});
}


