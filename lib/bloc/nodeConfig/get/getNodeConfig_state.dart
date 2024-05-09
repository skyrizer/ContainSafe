import 'package:equatable/equatable.dart';
import '../../../model/nodeConfig/nodeConfig.dart';

class GetAllNodeConfigState extends Equatable {
  const GetAllNodeConfigState();
  @override
  List<Object> get props => [];
}

class GetAllNodeConfigInitial extends GetAllNodeConfigState { }

class GetAllNodeConfigLoading extends GetAllNodeConfigState { }

class GetAllNodeConfigLoaded extends GetAllNodeConfigState {
  final List<NodeConfig> nodeConfigList;
  const GetAllNodeConfigLoaded({required this.nodeConfigList});
}

class GetAllNodeConfigError extends GetAllNodeConfigState {
  final String? error;
  const GetAllNodeConfigError({required this.error});
}

class GetAllNodeConfigEmpty extends GetAllNodeConfigState {}