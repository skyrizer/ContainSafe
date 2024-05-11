
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/permission_repo.dart';
import 'addPermission_event.dart';
import 'addPermission_state.dart';

class AddPermissionBloc extends Bloc<AddPermissionEvents, AddPermissionState>{

  PermissionRepository repo;

  AddPermissionBloc(AddPermissionState initialState, this.repo): super(initialState){

    on<StartRegister>((event,emit){
      emit(AddPermissionInitState());
    });

    on<AddPermissionButtonPressed>((event,emit) async{
      emit(AddPermissionLoadingState());
      int isSuccess = await repo.addPermission(
          event.name);
      if (isSuccess == 0){
        emit(AddPermissionSuccessState());
      } else if (isSuccess == 3){
        emit(AddPermissionFailState(message: 'Fail to add new permision'));
      }
    });
  }
}