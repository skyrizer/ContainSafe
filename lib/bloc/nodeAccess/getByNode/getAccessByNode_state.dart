import 'package:containsafe/model/node/node.dart';
import 'package:equatable/equatable.dart';

import '../../../model/nodeAccess/nodeAccess.dart';
import '../../../model/nodeConfig/nodeConfig.dart';

class GetAccessByNodeState extends Equatable {
  const GetAccessByNodeState();
  @override
  List<Object> get props => [];
}

class GetAccessByNodeInitial extends GetAccessByNodeState { }

class GetAccessByNodeLoading extends GetAccessByNodeState { }

class GetAccessByNodeLoaded extends GetAccessByNodeState {
  final List<NodeAccess> nodeAccessList;
  const GetAccessByNodeLoaded({required this.nodeAccessList});
}

class GetAccessByNodeError extends GetAccessByNodeState {
  final String? error;
  const GetAccessByNodeError({required this.error});
}

class GetAccessByNodeEmpty extends GetAccessByNodeState {}