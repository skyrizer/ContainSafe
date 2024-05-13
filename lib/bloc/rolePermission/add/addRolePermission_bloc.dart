
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/rolePermission_repo.dart';
import 'addRolePermission_event.dart';
import 'addRolePermission_state.dart';

class AddRolePermissionBloc extends Bloc<AddRolePermissionEvents, AddRolePermissionState>{

  RolePermissionRepository repo;

  AddRolePermissionBloc(AddRolePermissionState initialState, this.repo): super(initialState){

    on<StartRegister>((event,emit){
      emit(AddRolePermissionInitState());
    });

    on<AddRolePermissionButtonPressed>((event,emit) async{
      emit(AddRolePermissionLoadingState());
      int isSuccess = await repo.addRolePermission(
          event.roleId,event.permissionId);
      if (isSuccess == 0){
        emit(AddRolePermissionSuccessState());
      } else if (isSuccess == 3){
        emit(AddRolePermissionFailState(message: 'Fail to add new role permission'));
      }
    });
  }
}