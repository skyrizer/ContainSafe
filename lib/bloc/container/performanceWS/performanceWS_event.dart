import 'package:equatable/equatable.dart';

abstract class PerformanceWSEvent extends Equatable {
  const PerformanceWSEvent();

  @override
  List<Object> get props => [];
}

class LoadPerformanceWSData extends PerformanceWSEvent {
  final String ipAddress;

  const LoadPerformanceWSData(this.ipAddress);
}
