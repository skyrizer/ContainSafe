
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/nodeAccess_repo.dart';
import 'addNodeAccess_event.dart';
import 'addNodeAccess_state.dart';

class AddNodeAccessBloc extends Bloc<AddNodeAccessEvents, AddNodeAccessState>{

  NodeAccessRepository repo;

  AddNodeAccessBloc(AddNodeAccessState initialState, this.repo): super(initialState){

    on<StartRegister>((event,emit){
      emit(AddNodeAccessInitState());
    });

    on<AddNodeAccessButtonPressed>((event,emit) async{
      emit(AddNodeAccessLoadingState());
      int isSuccess = await repo.addNodeAccess(
          event.userId,event.nodeId, event.roleId);
      if (isSuccess == 0){
        emit(AddNodeAccessSuccessState());
      } else if (isSuccess == 3){
        emit(AddNodeAccessFailState(message: 'Fail to add new node access'));
      }
    });
  }
}