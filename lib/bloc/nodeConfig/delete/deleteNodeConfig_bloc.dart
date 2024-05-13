import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/nodeConfig_repo.dart';
import 'deleteNodeConfig_event.dart';
import 'deleteNodeConfig_state.dart';

class DeleteNodeConfigBloc extends Bloc<DeleteNodeConfigEvents, DeleteNodeConfigState>{

  NodeConfigRepository nodeConfigRepo;

  DeleteNodeConfigBloc(DeleteNodeConfigState initialState, this.nodeConfigRepo,):super(initialState){

    on<StartDeleteNodeConfig>((event, emit){
      emit(DeleteNodeConfigInitState());
    });

    on<DeleteNodeConfigButtonPressed>((event, emit) async{
      emit(DeleteNodeConfigLoadingState());

      bool isCreated = await nodeConfigRepo.deleteNodeConfig(event.nodeId, event.configId);
      if (isCreated) {
        emit(DeleteNodeConfigSuccessState());
      } else {
        emit(DeleteNodeConfigFailState(message: "Fail to delete node config"));
      }
    });

  }
}
