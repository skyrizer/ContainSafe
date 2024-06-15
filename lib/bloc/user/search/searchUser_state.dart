import 'dart:io';

import 'package:equatable/equatable.dart';
import '../../../model/user/user.dart';
import '/../model/httpResponse/httpResponse.dart';

class SearchUserState extends Equatable{
  @override
  List<Object> get props => [];
}
// for seaching UI
class SearchUserInitState extends SearchUserState{}

class SearchUserLoadingState extends SearchUserState {}

class SearchUserEmptyState extends SearchUserState {}

class SearchUserLoadedState extends SearchUserState {
  List<User> userList;
  SearchUserLoadedState({ required this.userList});
}

class SearchUserErrorState extends SearchUserState {
  String message;
  SearchUserErrorState({ required this.message});

}

// // displaying UI
// class SearchUserProfileLoaded extends SearchByCodeState {
//   final UserModel user;
//   SearchUserProfileLoaded({ required this.user });
// }
//
// class SearchUserProfileError extends SearchByCodeState{
//   final String message;
//   SearchUserProfileError({ required this.message });
// }