import 'package:equatable/equatable.dart';
import '../../../model/container/container.dart';

class EditNodeState extends Equatable{
  @override
  List<Object> get props => [];
}


class EditNodeUpdating extends EditNodeState {}

class EditNodeUpdated extends EditNodeState {}

class EditNodeError extends EditNodeState {
  EditNodeError({required String message});
}