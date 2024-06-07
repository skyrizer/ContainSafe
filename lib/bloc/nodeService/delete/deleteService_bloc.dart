import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/nodeAccess_repo.dart';
import '../../../repository/nodeService_repo.dart';
import 'deleteService_event.dart';
import 'deleteService_state.dart';

class DeleteNodeServiceBloc extends Bloc<DeleteNodeServiceEvents, DeleteNodeServiceState>{

  NodeServiceRepository nodeServiceRepo;

  DeleteNodeServiceBloc(DeleteNodeServiceState initialState, this.nodeServiceRepo,):super(initialState){

    on<StartDeleteNodeService>((event, emit){
      emit(DeleteNodeServiceInitState());
    });

    on<DeleteServiceButtonPressed>((event, emit) async{
      emit(DeleteNodeServiceLoadingState());

      bool isCreated = await nodeServiceRepo.deleteNodeService(event.serviceId, event.nodeId);
      if (isCreated) {
        emit(DeleteNodeServiceSuccessState());
      } else {
        emit(DeleteNodeServiceFailState(message: "Fail to delete node service"));
      }
    });

  }
}
