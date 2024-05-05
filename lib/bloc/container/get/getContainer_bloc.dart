
import 'package:containsafe/repository/container_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/container/container.dart';
import 'getContainer_event.dart';
import 'getContainer_state.dart';

class GetContainerBloc extends Bloc<GetContainerEvent, GetContainerState>{

  ContainerRepository containerRepo;

  GetContainerBloc(GetContainerState initialState, this.containerRepo):super(initialState){

    on<StartLoadContainer>((event, emit) async {
      
      emit(GetContainerLoadingState());
      
      ContainerModel? isFound = await containerRepo.getContainer(event.containerId);

      if (isFound != null){
        emit(GetContainerLoadedState(container: isFound));
      } else{
        GetContainerErrorState(message: "Fail to load user profile");
      }
    });

    on<UpdateButtonPressed>((event, emit) async {
      emit(GetContainerUpdating());
      bool isUpdated = await containerRepo.updateContainer(event.container);
      if (isUpdated){
        emit(GetContainerUpdated());
      } else{
        emit(GetContainerErrorState(message: "Error in updating"));
      }
    });
  }
}