
import 'package:containsafe/bloc/node/update/updateNode_event.dart';
import 'package:containsafe/bloc/node/update/updateNode_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/node_repo.dart';
class EditNodeBloc extends Bloc<EditNodeEvent, EditNodeState>{

  NodeRepository nodeRepo;

  EditNodeBloc(EditNodeState initialState, this.nodeRepo):super(initialState){


    on<UpdateNodeButtonPressed>((event, emit) async {
      emit(EditNodeUpdating());
      bool isUpdated = await nodeRepo.updateNode(event.node);
      if (isUpdated){
        emit(EditNodeUpdated());
      } else{
        emit(EditNodeError(message: "Error in updating"));
      }
    });
  }
}