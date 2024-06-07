import 'package:equatable/equatable.dart';

class DeleteNodeServiceState extends Equatable{
  @override
  List<Object> get props => [];
}

// Delete Node Access
class DeleteNodeServiceInitState extends DeleteNodeServiceState {}

class DeleteNodeServiceLoadingState extends DeleteNodeServiceState {}

class DeleteNodeServiceSuccessState extends DeleteNodeServiceState {}

class DeleteNodeServiceFailState extends DeleteNodeServiceState {
  final String message;
  DeleteNodeServiceFailState({required this.message});
}


