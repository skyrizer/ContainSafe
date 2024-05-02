import 'package:containsafe/bloc/container/performance/performance_event.dart';
import 'package:containsafe/bloc/container/performance/performance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../repository/performance_repo.dart';
import '/../model/performance/performance_model.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class PerformanceBloc extends Bloc<PerformanceEvent, PerformanceState> {

  final PerformanceRepository performanceRepository = PerformanceRepository();

  PerformanceBloc() : super(GetAllPerformanceInitial()) {
    on<GetAllPerformanceList>((event, emit) async {
      try {
        emit(GetAllPerformanceLoading());
        final List<Performance> allPerformanceList = await performanceRepository
            .getAllPerformances();
        emit(GetAllPerformanceLoaded(allPerformanceList: allPerformanceList));

        if (allPerformanceList[0].error != "") {
          emit(GetAllPerformanceError(
              error: allPerformanceList[0].error));
        }
      } on http.ClientException {
        emit(const GetAllPerformanceError(
            error: "Failed to fetch data in your device online"));
      }
    });
  }
}
