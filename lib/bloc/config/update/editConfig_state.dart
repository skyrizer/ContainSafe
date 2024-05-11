import 'package:equatable/equatable.dart';
import '../../../model/container/container.dart';

class EditConfigState extends Equatable{
  @override
  List<Object> get props => [];
}


class EditConfigUpdating extends EditConfigState {}

class EditConfigUpdated extends EditConfigState {}

class EditConfigError extends EditConfigState {
  EditConfigError({required String message});
}