import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../model/backgroundProcess/backgroundProcess.dart';
import '../../../model/nodeAccess/nodeAccess.dart';
import '../../../repository/backgroundProcess_repo.dart';
import '../../../repository/nodeAccess_repo.dart';
import 'getBpService_event.dart';
import 'getBpService_state.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class GetBpByServiceBloc extends Bloc<GetBpByServiceEvent, GetBpByServiceState> {

  final BackgroundProcessRepository bpRepository = BackgroundProcessRepository();

  GetBpByServiceBloc() : super(GetBpByServiceInitial()) {

    on<GetBpByServiceList>((event, emit) async {
      try {
        emit(GetBpByServiceLoading());
        final List<BackgroundProcess> bpServiceList = await bpRepository
            .getBpByService(event.serviceId);
        emit(GetBpByServiceLoaded(bpServiceList: bpServiceList));

        if (bpServiceList[0].error != "") {
          emit(GetBpByServiceError(
              error: bpServiceList[0].error));
        }
      } on http.ClientException {
        emit(const GetBpByServiceError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
