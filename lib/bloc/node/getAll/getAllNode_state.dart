import 'package:containsafe/model/node/node.dart';
import 'package:equatable/equatable.dart';

class GetAllNodeState extends Equatable {
  const GetAllNodeState();
  @override
  List<Object> get props => [];
}

class GetAllNodeInitial extends GetAllNodeState { }

class GetAllNodeLoading extends GetAllNodeState { }

class GetAllNodeLoaded extends GetAllNodeState {
  final List<Node> nodeList;
  const GetAllNodeLoaded({required this.nodeList});
}

class GetAllNodeError extends GetAllNodeState {
  final String? error;
  const GetAllNodeError({required this.error});
}

class GetAllNodeEmpty extends GetAllNodeState {}