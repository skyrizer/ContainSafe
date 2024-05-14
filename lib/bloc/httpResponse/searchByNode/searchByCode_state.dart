import 'dart:io';

import 'package:equatable/equatable.dart';
import '/../model/httpResponse/httpResponse.dart';

class SearchByCodeState extends Equatable{
  @override
  List<Object> get props => [];
}
// for seaching UI
class SearchByCodeInitState extends SearchByCodeState{}

class SearchByCodeLoadingState extends SearchByCodeState {}

class SearchByCodeEmptyState extends SearchByCodeState {}

class SearchByCodeLoadedState extends SearchByCodeState {
  List<HttpResponse> searchByCodeList;
  SearchByCodeLoadedState({ required this.searchByCodeList});
}

class SearchByCodeErrorState extends SearchByCodeState {
  String message;
  SearchByCodeErrorState({ required this.message});

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