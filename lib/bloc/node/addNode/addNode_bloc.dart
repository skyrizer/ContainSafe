
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/node_repo.dart';
import 'addNode_event.dart';
import 'addNode_state.dart';

class AddNodeBloc extends Bloc<AddNodeEvents, AddNodeState>{

  NodeRepository repo;

  AddNodeBloc(AddNodeState initialState, this.repo): super(initialState){

    on<StartRegister>((event,emit){
      emit(AddNodeInitState());
    });

    on<AddNodeButtonPressed>((event,emit) async{
      emit(AddNodeLoadingState());
      int isSuccess = await repo.addNode(
          event.hostname,event.ipAddress);
      if (isSuccess == 0){
        emit(AddNodeSuccessState());
      } else if (isSuccess == 3){
        emit(AddNodeFailState(message: 'Fail to add new node'));
      }
    });
  }
}