import 'package:equatable/equatable.dart';

class DeleteBpState extends Equatable{
  @override
  List<Object> get props => [];
}

// Delete Node Access
class DeleteBpInitState extends DeleteBpState {}

class DeleteBpLoadingState extends DeleteBpState {}

class DeleteBpSuccessState extends DeleteBpState {}

class DeleteBpFailState extends DeleteBpState {
  final String message;
  DeleteBpFailState({required this.message});
}


