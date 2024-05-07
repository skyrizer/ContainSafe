import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../repository/node_repo.dart';
import '../../repository/httpResponse_repo.dart';
import '/../model/httpResponse/httpResponse.dart';
import 'httpResponse_event.dart';
import 'httpResponse_state.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class GetHttpResponsesBloc extends Bloc<GetHttpResponsesEvent, GetHttpResponsesState> {

  final HttpResponseRepository httpReponseRepository = HttpResponseRepository();

  GetHttpResponsesBloc() : super(GetHttpResponsesInitial()) {

    on<GetHttpResponses>((event, emit) async {
      try {
        emit(GetHttpResponsesLoading());
        final List<HttpResponse> httpResponses = await httpReponseRepository.getHttpResponses();
        emit(GetHttpResponsesLoaded(httpResponses: httpResponses));

        if (httpResponses[0].error != "") {
          emit(GetHttpResponsesError(
              error: httpResponses[0].error));
        }
      } on http.ClientException {
        emit(const GetHttpResponsesError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
