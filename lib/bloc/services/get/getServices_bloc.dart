import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../model/role/role.dart';
import '../../../model/service/service_model..dart';
import '../../../repository/service_repo.dart';
import 'getServices_event.dart';
import 'getServices_state.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class GetAllServiceBloc extends Bloc<GetAllServiceEvent, GetAllServiceState> {

  final ServiceRepository serviceRepository = ServiceRepository();

  GetAllServiceBloc() : super(GetAllServiceInitial()) {

    on<GetAllServiceList>((event, emit) async {
      try {
        emit(GetAllServiceLoading());
        final List<ServiceModel> serviceList = await serviceRepository
            .getAllServices();
        emit(GetAllServiceLoaded(serviceList: serviceList));

        if (serviceList[0].error != null) {
          emit(GetAllServiceError(
              error: serviceList[0].error));
        }
      } on http.ClientException {
        emit(const GetAllServiceError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
