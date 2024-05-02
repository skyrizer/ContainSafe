import 'package:containsafe/model/performance/performance_model.dart';
import 'package:equatable/equatable.dart';

class PerformanceState extends Equatable {
  const PerformanceState();
  @override
  List<Object> get props => [];
}

class GetAllPerformanceInitial extends PerformanceState { }

class GetAllPerformanceLoading extends PerformanceState { }

class GetAllPerformanceLoaded extends PerformanceState {
  final List<Performance> allPerformanceList;
  const GetAllPerformanceLoaded({required this.allPerformanceList});
}

class GetAllPerformanceError extends PerformanceState {
  final String? error;
  const GetAllPerformanceError({required this.error});
}

class GetAllPerformanceEmpty extends PerformanceState {}