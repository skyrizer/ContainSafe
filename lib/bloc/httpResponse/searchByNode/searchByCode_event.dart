import 'package:equatable/equatable.dart';

class SearchByCodeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchByCodeInitEvent extends SearchByCodeEvent {}

class SearchByCodePressed extends SearchByCodeEvent {
  final int statusCode;
  SearchByCodePressed({ required this.statusCode });
}

// class SearchUserProfileEvent extends SearchByCodeEvent {
//   final int userid;
//   SearchUserProfileEvent({ required this.userid });
// }