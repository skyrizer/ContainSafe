import 'package:equatable/equatable.dart';

class DeleteNodeState extends Equatable{
  @override
  List<Object> get props => [];
}

// Delete Posts
class DeleteNodeInitState extends DeleteNodeState {}

class DeleteNodeLoadingState extends DeleteNodeState {}

class DeleteNodeSuccessState extends DeleteNodeState {}

class DeleteNodeFailState extends DeleteNodeState {
  final String message;
  DeleteNodeFailState({required this.message});
}


