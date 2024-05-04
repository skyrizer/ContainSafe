import 'package:equatable/equatable.dart';

class PerformanceEvent extends Equatable {
  const PerformanceEvent();

  @override
  List<Object> get props => [];
}

class GetAllPerformanceList extends PerformanceEvent {
  final int? nodeId; // Add nodeId parameter

  const GetAllPerformanceList({this.nodeId}); // Constructor with optional nodeId parameter

  // @override
  // List<Object> get props => [nodeId]; // Include nodeId in props list
}