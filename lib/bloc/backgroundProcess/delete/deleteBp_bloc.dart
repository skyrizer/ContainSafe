import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/backgroundProcess_repo.dart';
import '../../../repository/nodeAccess_repo.dart';
import '../../../repository/node_repo.dart';
import 'deleteBp_event.dart';
import 'deleteBp_state.dart';

class DeleteBpBloc extends Bloc<DeleteBpEvents, DeleteBpState>{

  BackgroundProcessRepository bpRepo;

  DeleteBpBloc(DeleteBpState initialState, this.bpRepo,):super(initialState){

    on<StartDeleteBp>((event, emit){
      emit(DeleteBpInitState());
    });

    on<DeleteBpButtonPressed>((event, emit) async{
      emit(DeleteBpLoadingState());

      bool isCreated = await bpRepo.DeleteBackgroundProcess(event.serviceId, event.bpId);
      if (isCreated) {
        emit(DeleteBpSuccessState());
      } else {
        emit(DeleteBpFailState(message: "Fail to delete node access"));
      }
    });

  }
}
