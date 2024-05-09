import 'package:containsafe/model/node/node.dart';
import 'package:equatable/equatable.dart';

import '../../../model/nodeConfig/nodeConfig.dart';

class GetConfigByNodeState extends Equatable {
  const GetConfigByNodeState();
  @override
  List<Object> get props => [];
}

class GetConfigByNodeInitial extends GetConfigByNodeState { }

class GetConfigByNodeLoading extends GetConfigByNodeState { }

class GetConfigByNodeLoaded extends GetConfigByNodeState {
  final List<NodeConfig> nodeConfigList;
  const GetConfigByNodeLoaded({required this.nodeConfigList});
}

class GetConfigByNodeError extends GetConfigByNodeState {
  final String? error;
  const GetConfigByNodeError({required this.error});
}

class GetConfigByNodeEmpty extends GetConfigByNodeState {}