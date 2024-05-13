import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/nodeAccess_repo.dart';
import '../../../repository/node_repo.dart';
import 'deleteAccess_event.dart';
import 'deleteAccess_state.dart';

class DeleteNodeAccessBloc extends Bloc<DeleteNodeAccessEvents, DeleteNodeAccessState>{

  NodeAccessRepository nodeAccessRepo;

  DeleteNodeAccessBloc(DeleteNodeAccessState initialState, this.nodeAccessRepo,):super(initialState){

    on<StartDeleteNodeAccess>((event, emit){
      emit(DeleteNodeAccessInitState());
    });

    on<DeleteAccessButtonPressed>((event, emit) async{
      emit(DeleteNodeAccessLoadingState());

      bool isCreated = await nodeAccessRepo.deleteNodeAccess(event.nodeId, event.userId, event.roleId);
      if (isCreated) {
        emit(DeleteNodeAccessSuccessState());
      } else {
        emit(DeleteNodeAccessFailState(message: "Fail to delete node access"));
      }
    });

  }
}
