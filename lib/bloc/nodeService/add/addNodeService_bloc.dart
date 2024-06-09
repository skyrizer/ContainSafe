
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/nodeService_repo.dart';
import 'addNodeService_event.dart';
import 'addNodeService_state.dart';

class AddNodeServiceBloc extends Bloc<AddNodeServiceEvents, AddNodeServiceState>{

  NodeServiceRepository repo;

  AddNodeServiceBloc(AddNodeServiceState initialState, this.repo): super(initialState){

    on<StartNodeServiceRegister>((event,emit){
      emit(AddNodeServiceInitState());
    });

    on<AddNodeServiceButtonPressed>((event,emit) async{
      emit(AddNodeServiceLoadingState());
      int isSuccess = await repo.addNodeService(
          event.serviceId,event.nodeId);
      if (isSuccess == 0){
        emit(AddNodeServiceSuccessState());
      } else if (isSuccess == 3){
        emit(AddNodeServiceFailState(message: 'Fail to add new node service'));
      }
    });
  }
}