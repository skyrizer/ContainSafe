
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/config_repo.dart';
import '../../../repository/node_repo.dart';
import 'addConfig_event.dart';
import 'addConfig_state.dart';

class AddConfigBloc extends Bloc<AddConfigEvents, AddConfigState>{

  ConfigRepository repo;

  AddConfigBloc(AddConfigState initialState, this.repo): super(initialState){

    on<StartRegister>((event,emit){
      emit(AddConfigInitState());
    });

    on<AddConfigButtonPressed>((event,emit) async{
      emit(AddConfigLoadingState());
      int isSuccess = await repo.addConfig(
          event.name,event.unit);
      if (isSuccess == 0){
        emit(AddConfigSuccessState());
      } else if (isSuccess == 3){
        emit(AddConfigFailState(message: 'Fail to add new node'));
      }
    });
  }
}