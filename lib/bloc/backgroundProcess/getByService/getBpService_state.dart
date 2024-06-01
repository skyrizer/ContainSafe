import 'package:containsafe/model/node/node.dart';
import 'package:equatable/equatable.dart';

import '../../../model/backgroundProcess/backgroundProcess.dart';
import '../../../model/nodeAccess/nodeAccess.dart';
import '../../../model/nodeConfig/nodeConfig.dart';

class GetBpByServiceState extends Equatable {
  const GetBpByServiceState();
  @override
  List<Object> get props => [];
}

class GetBpByServiceInitial extends GetBpByServiceState { }

class GetBpByServiceLoading extends GetBpByServiceState { }

class GetBpByServiceLoaded extends GetBpByServiceState {
  final List<BackgroundProcess> bpServiceList;
  const GetBpByServiceLoaded({required this.bpServiceList});
}

class GetBpByServiceError extends GetBpByServiceState {
  final String? error;
  const GetBpByServiceError({required this.error});
}

class GetAccessByNodeEmpty extends GetBpByServiceState {}