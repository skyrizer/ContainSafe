
import 'package:containsafe/model/backgroundProcess/backgroundProcess.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/backgroundProcess_repo.dart';
import '../../../repository/config_repo.dart';
import 'addBp_event.dart';
import 'addBp_state.dart';

class AddBpBloc extends Bloc<AddBpEvents, AddBpState>{

  BackgroundProcessRepository repo;

  AddBpBloc(AddBpState initialState, this.repo): super(initialState){

    on<StartRegister>((event,emit){
      emit(AddBpInitState());
    });

    on<AddBpButtonPressed>((event,emit) async{
      emit(AddBpLoadingState());
      int isSuccess = await repo.addBackgroundProcess(
          event.name,event.serviceId);
      if (isSuccess == 0){
        emit(AddBpSuccessState());
      } else if (isSuccess == 3){
        emit(AddBpFailState(message: 'Fail to add new background service'));
      }
    });
  }
}