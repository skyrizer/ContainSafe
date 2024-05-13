import 'package:containsafe/model/rolePermission/rolePermission.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/nodeConfig_repo.dart';
import '../../../repository/rolePermission_repo.dart';
import 'delRolePermission_event.dart';
import 'delRolePermission_state.dart';

class DeleteRolePermissionBloc extends Bloc<DeleteRolePermissionEvents, DeleteRolePermissionState>{

  RolePermissionRepository rolePermissionRepo;

  DeleteRolePermissionBloc(DeleteRolePermissionState initialState, this.rolePermissionRepo,):super(initialState){

    on<StartDeleteRolePermission>((event, emit){
      emit(DeleteRolePermissionInitState());
    });

    on<DeleteRolePermissionButtonPressed>((event, emit) async{
      emit(DeleteRolePermissionLoadingState());

      bool isCreated = await rolePermissionRepo.deleteRolePermission(event.roleId, event.permissionId);
      if (isCreated) {
        emit(DeleteRolePermissionSuccessState());
      } else {
        emit(DeleteRolePermissionFailState(message: "Fail to delete role permission"));
      }
    });

  }
}
