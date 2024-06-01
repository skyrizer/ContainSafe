
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/service_repo.dart';
import 'addService_event.dart';
import 'addService_state.dart';

class AddServiceBloc extends Bloc<AddServiceEvents, AddServiceState>{

  ServiceRepository repo;

  AddServiceBloc(AddServiceState initialState, this.repo): super(initialState){

    on<StartRegister>((event,emit){
      emit(AddServiceInitState());
    });

    on<AddServiceButtonPressed>((event,emit) async{
      emit(AddServiceLoadingState());
      int isSuccess = await repo.addService(
          event.name);
      if (isSuccess == 0){
        emit(AddServiceSuccessState());
      } else if (isSuccess == 3){
        emit(AddServiceFailState(message: 'Fail to add new service'));
      }
    });
  }
}