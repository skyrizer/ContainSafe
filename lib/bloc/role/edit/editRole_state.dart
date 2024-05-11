import 'package:equatable/equatable.dart';
import '../../../model/container/container.dart';

class EditRoleState extends Equatable{
  @override
  List<Object> get props => [];
}


class EditRoleUpdating extends EditRoleState {}

class EditRoleUpdated extends EditRoleState {}

class EditRoleError extends EditRoleState {
  EditRoleError({required String message});
}