import 'package:equatable/equatable.dart';
import 'package:containsafe/model/performance/performanceWS.dart';

abstract class PerformanceWSState extends Equatable {
  const PerformanceWSState();

  @override
  List<Object> get props => [];
}

class PerformanceWSLoading extends PerformanceWSState {}

class PerformanceWSLoaded extends PerformanceWSState {
  final List<PerformanceWS> performanceList;

  const PerformanceWSLoaded(this.performanceList);

  @override
  List<Object> get props => [performanceList];
}

class PerformanceWSEmpty extends PerformanceWSState{}

class PerformanceWSError extends PerformanceWSState {
  final String error;

  const PerformanceWSError(this.error);

  @override
  List<Object> get props => [error];
}
