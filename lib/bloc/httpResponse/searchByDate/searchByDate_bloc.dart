

import 'package:containsafe/bloc/httpResponse/searchByDate/searchByDate_event.dart';
import 'package:containsafe/bloc/httpResponse/searchByDate/searchByDate_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/../model/httpResponse/httpResponse.dart';
import '../../../repository/httpResponse_repo.dart';

class SearchByDateBloc extends Bloc<SearchByDateEvent, SearchByDateState> {
  HttpResponseRepository repo;

  SearchByDateBloc(SearchByDateState initialState, this.repo) :super(initialState) {
    on<SearchByDateInitEvent>((event, emit) {
      emit(SearchByDateInitState());
    });

    on<SearchByDatePressed>((event, emit) async {
      emit(SearchByDateLoadingState());
      final List<HttpResponse> httpResponses = await repo.searchByDate(event.startDate, event.endDate);
      if (httpResponses.length > 0) {
        emit(SearchByDateLoadedState(searchByDateList: httpResponses));
      }
      else {
        emit(SearchByDateEmptyState());
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