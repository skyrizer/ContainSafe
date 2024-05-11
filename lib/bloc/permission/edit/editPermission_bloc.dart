
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/permission_repo.dart';
import '../../../repository/role_repo.dart';
import 'editPermission_event.dart';
import 'editPermission_state.dart';

class EditPermissionBloc extends Bloc<EditPermissionEvent, EditPermissionState>{

  PermissionRepository repo;

  EditPermissionBloc(EditPermissionState initialState, this.repo):super(initialState){


    on<UpdatePermissionButtonPressed>((event, emit) async {
      emit(EditPermissionUpdating());
      bool isUpdated = await repo.updatePermission(event.permission);
      if (isUpdated){
        emit(EditPermissionUpdated());
      } else{
        emit(EditPermissionError(message: "Error in updating"));
      }
    });
  }
}