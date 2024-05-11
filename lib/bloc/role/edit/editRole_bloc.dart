
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/config_repo.dart';
import '../../../repository/role_repo.dart';
import 'editRole_event.dart';
import 'editRole_state.dart';

class EditRoleBloc extends Bloc<EditRoleEvent, EditRoleState>{

  RoleRepository roleRepo;

  EditRoleBloc(EditRoleState initialState, this.roleRepo):super(initialState){


    on<UpdateRoleButtonPressed>((event, emit) async {
      emit(EditRoleUpdating());
      bool isUpdated = await roleRepo.updateRole(event.role);
      if (isUpdated){
        emit(EditRoleUpdated());
      } else{
        emit(EditRoleError(message: "Error in updating"));
      }
    });
  }
}