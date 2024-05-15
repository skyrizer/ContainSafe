import 'package:equatable/equatable.dart';

class SearchByDateEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchByDateInitEvent extends SearchByDateEvent {}

class SearchByDatePressed extends SearchByDateEvent {
  final String startDate;
  final String endDate;

  SearchByDatePressed({ required this.startDate, required this.endDate });
}

// class SearchUserProfileEvent extends SearchByCodeEvent {
//   final int userid;
//   SearchUserProfileEvent({ required this.userid });
// }