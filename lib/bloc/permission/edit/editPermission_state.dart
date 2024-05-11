import 'package:equatable/equatable.dart';
import '../../../model/container/container.dart';

class EditPermissionState extends Equatable{
  @override
  List<Object> get props => [];
}


class EditPermissionUpdating extends EditPermissionState {}

class EditPermissionUpdated extends EditPermissionState {}

class EditPermissionError extends EditPermissionState {
  EditPermissionError({required String message});
}