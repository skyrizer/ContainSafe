import 'package:equatable/equatable.dart';

import '../../../model/config/config.dart';
import '../../../model/container/container.dart';
import '../../../model/role/role.dart';

class EditRoleEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class UpdateRoleButtonPressed extends EditRoleEvent {
  Role role;
  UpdateRoleButtonPressed({ required this.role });
}