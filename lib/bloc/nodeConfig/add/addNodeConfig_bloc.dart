
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/nodeConfig_repo.dart';
import 'addNodeConfig_event.dart';
import 'addNodeConfig_state.dart';

class AddNodeConfigBloc extends Bloc<AddNodeConfigEvents, AddNodeConfigState>{

  NodeConfigRepository repo;

  AddNodeConfigBloc(AddNodeConfigState initialState, this.repo): super(initialState){

    on<StartRegister>((event,emit){
      emit(AddNodeConfigInitState());
    });

    on<AddNodeConfigButtonPressed>((event,emit) async{
      emit(AddNodeConfigLoadingState());
      int isSuccess = await repo.addNodeConfig(
          event.configId,event.nodeId, event.value);
      if (isSuccess == 0){
        emit(AddNodeConfigSuccessState());
      } else if (isSuccess == 3){
        emit(AddNodeConfigFailState(message: 'The node already have the configuration'));
      }
    });
  }
}