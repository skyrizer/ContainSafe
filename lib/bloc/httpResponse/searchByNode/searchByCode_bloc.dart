
import 'dart:io';

import 'package:containsafe/bloc/httpResponse/searchByNode/searchByCode_event.dart';
import 'package:containsafe/bloc/httpResponse/searchByNode/searchByCode_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/../model/httpResponse/httpResponse.dart';
import '../../../repository/httpResponse_repo.dart';

class SearchByCodeBloc extends Bloc<SearchByCodeEvent, SearchByCodeState> {
  HttpResponseRepository repo;

  SearchByCodeBloc(SearchByCodeState initialState, this.repo) :super(initialState) {
    on<SearchByCodeInitEvent>((event, emit) {
      emit(SearchByCodeInitState());
    });

    on<SearchByCodePressed>((event, emit) async {
      emit(SearchByCodeLoadingState());
      final List<HttpResponse> httpResponses = await repo.searchByCode(event.statusCode);
      if (httpResponses.length > 0) {
        emit(SearchByCodeLoadedState(searchByCodeList: httpResponses));
      }
      else {
        emit(SearchByCodeEmptyState());
      }
    });

  //   on<SearchUserProfileEvent>((event, emit) async{
  //     emit(SearchUserLoadingState());
  //     UserModel? isFound = await repo.getSearchUserInfo(event.userid);
  //     if (isFound != null){
  //       emit(SearchUserProfileLoaded(user: isFound));
  //     }
  //     else {
  //       emit(SearchUserProfileError(message: "Unable to load user"));
  //     }
  //   });
   }

}