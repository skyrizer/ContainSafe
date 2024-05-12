import 'package:equatable/equatable.dart';

class DeleteNodeAccessState extends Equatable{
  @override
  List<Object> get props => [];
}

// Delete Node Access
class DeleteNodeAccessInitState extends DeleteNodeAccessState {}

class DeleteNodeAccessLoadingState extends DeleteNodeAccessState {}

class DeleteNodeAccessSuccessState extends DeleteNodeAccessState {}

class DeleteNodeAccessFailState extends DeleteNodeAccessState {
  final String message;
  DeleteNodeAccessFailState({required this.message});
}


