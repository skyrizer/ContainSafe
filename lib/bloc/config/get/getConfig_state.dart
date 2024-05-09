import 'package:equatable/equatable.dart';
import '../../../model/config/config.dart';

class GetAllConfigState extends Equatable {
  const GetAllConfigState();
  @override
  List<Object> get props => [];
}

class GetAllConfigInitial extends GetAllConfigState { }

class GetAllConfigLoading extends GetAllConfigState { }

class GetAllConfigLoaded extends GetAllConfigState {
  final List<Config> configList;
  const GetAllConfigLoaded({required this.configList});
}

class GetAllNodeError extends GetAllConfigState {
  final String? error;
  const GetAllNodeError({required this.error});
}

class GetAllNodeEmpty extends GetAllConfigState {}