
import 'dart:io';

import 'package:containsafe/bloc/httpResponse/searchByNode/searchByCode_event.dart';
import 'package:containsafe/bloc/httpResponse/searchByNode/searchByCode_state.dart';
import 'package:containsafe/bloc/user/search/searchUser_event.dart';
import 'package:containsafe/bloc/user/search/searchUser_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/user/user.dart';
import '../../../repository/user_repo.dart';
import '/../model/httpResponse/httpResponse.dart';
import '../../../repository/httpResponse_repo.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {

  UserRepository repo;

  SearchUserBloc(SearchUserState initialState, this.repo) :super(initialState) {
    on<SearchUserInitEvent>((event, emit) {
      emit(SearchUserInitState());
    });

    on<SearchUserPressed>((event, emit) async {
      emit(SearchUserLoadingState());
      final List<User> users = await repo.searchUser(event.name);
      if (users.length > 0) {
        emit(SearchUserLoadedState(userList: users));
      }
      else {
        emit(SearchUserEmptyState());
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