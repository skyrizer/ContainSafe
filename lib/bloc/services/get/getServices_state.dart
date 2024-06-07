
import 'package:equatable/equatable.dart';
import '../../../model/service/service_model..dart';

class GetAllServiceState extends Equatable {
  const GetAllServiceState();
  @override
  List<Object> get props => [];
}

class GetAllServiceInitial extends GetAllServiceState { }

class GetAllServiceLoading extends GetAllServiceState { }

class GetAllServiceLoaded extends GetAllServiceState {
  final List<ServiceModel> serviceList;
  const GetAllServiceLoaded({required this.serviceList});
}

class GetAllServiceError extends GetAllServiceState {
  final String? error;
  const GetAllServiceError({required this.error});
}

class GetAllServiceEmpty extends GetAllServiceState {}