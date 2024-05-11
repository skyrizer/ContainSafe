
import 'package:containsafe/repository/container_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/config_repo.dart';
import 'editConfig_event.dart';
import 'editConfig_state.dart';

class EditConfigBloc extends Bloc<EditConfigEvent, EditConfigState>{

  ConfigRepository configRepo;

  EditConfigBloc(EditConfigState initialState, this.configRepo):super(initialState){


    on<UpdateConfigButtonPressed>((event, emit) async {
      emit(EditConfigUpdating());
      bool isUpdated = await configRepo.updateConfig(event.config);
      if (isUpdated){
        emit(EditConfigUpdated());
      } else{
        emit(EditConfigError(message: "Error in updating"));
      }
    });
  }
}