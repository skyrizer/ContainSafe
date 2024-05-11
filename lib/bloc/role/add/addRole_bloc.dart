
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/role_repo.dart';
import 'addRole_event.dart';
import 'addRole_state.dart';

class AddRoleBloc extends Bloc<AddRoleEvents, AddRoleState>{

  RoleRepository repo;

  AddRoleBloc(AddRoleState initialState, this.repo): super(initialState){

    on<StartRegister>((event,emit){
      emit(AddRoleInitState());
    });

    on<AddRoleButtonPressed>((event,emit) async{
      emit(AddRoleLoadingState());
      int isSuccess = await repo.addRole(
          event.role);
      if (isSuccess == 0){
        emit(AddRoleSuccessState());
      } else if (isSuccess == 3){
        emit(AddRoleFailState(message: 'Fail to add new node'));
      }
    });
  }
}