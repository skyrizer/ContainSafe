import 'package:equatable/equatable.dart';

class AddConfigState extends Equatable{
  @override
  List<Object> get props => [];
}

class AddConfigInitState extends AddConfigState {}

class AddConfigLoadingState extends AddConfigState{}

class AddConfigSuccessState extends AddConfigState{}

class AddConfigFailState extends AddConfigState{
  final String message;
  AddConfigFailState({required this.message});
}