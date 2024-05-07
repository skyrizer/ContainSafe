import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/node_repo.dart';
import 'deleteNode_event.dart';
import 'deleteNode_state.dart';

class DeleteNodeBloc extends Bloc<DeleteNodeEvents, DeleteNodeState>{

  NodeRepository nodeRepo;

  DeleteNodeBloc(DeleteNodeState initialState, this.nodeRepo,):super(initialState){

    on<StartDeleteNode>((event, emit){
      emit(DeleteNodeInitState());
    });

    on<DeleteButtonPressed>((event, emit) async{
      emit(DeleteNodeLoadingState());

      bool isCreated = await nodeRepo.deleteNode(event.nodeId);
      if (isCreated) {
        emit(DeleteNodeSuccessState());
      } else {
        emit(DeleteNodeFailState(message: "Fail to delete post"));
      }
    });

  }
}
