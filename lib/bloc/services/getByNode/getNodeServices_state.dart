import 'package:containsafe/model/service/service_status.dart';
import 'package:equatable/equatable.dart';
import 'package:containsafe/model/performance/performanceWS.dart';

abstract class GetNodeServicesState extends Equatable {
  const GetNodeServicesState();

  @override
  List<Object> get props => [];
}

class GetServicesLoading extends GetNodeServicesState {}

class GetServicesLoaded extends GetNodeServicesState {
  final List<ServiceStatus> statusList;

  const GetServicesLoaded(this.statusList);

  @override
  List<Object> get props => [statusList];
}

class GetServicesEmpty extends GetNodeServicesState{}

class GetServicesError extends GetNodeServicesState {
  final String error;

  const GetServicesError(this.error);

  @override
  List<Object> get props => [error];
}
