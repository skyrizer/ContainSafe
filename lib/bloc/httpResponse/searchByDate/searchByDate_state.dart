import 'dart:io';

import 'package:equatable/equatable.dart';
import '/../model/httpResponse/httpResponse.dart';

class SearchByDateState extends Equatable{
  @override
  List<Object> get props => [];
}
// for seaching UI
class SearchByDateInitState extends SearchByDateState{}

class SearchByDateLoadingState extends SearchByDateState {}

class SearchByDateEmptyState extends SearchByDateState {}

class SearchByDateLoadedState extends SearchByDateState {
  List<HttpResponse> searchByDateList;
  SearchByDateLoadedState({ required this.searchByDateList});
}

class SearchByDateErrorState extends SearchByDateState {
  String message;
  SearchByDateErrorState({ required this.message});

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