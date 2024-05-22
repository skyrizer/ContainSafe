import 'package:containsafe/model/service/service_status.dart';
import 'package:equatable/equatable.dart';
import 'package:containsafe/model/performance/performanceWS.dart';

abstract class GetServicesState extends Equatable {
  const GetServicesState();

  @override
  List<Object> get props => [];
}

class GetServicesLoading extends GetServicesState {}

class GetServicesLoaded extends GetServicesState {
  final List<ServiceStatus> statusList;

  const GetServicesLoaded(this.statusList);

  @override
  List<Object> get props => [statusList];
}

class GetServicesEmpty extends GetServicesState{}

class GetServicesError extends GetServicesState {
  final String error;

  const GetServicesError(this.error);

  @override
  List<Object> get props => [error];
}
