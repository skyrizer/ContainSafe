import 'package:equatable/equatable.dart';


class GetBpByServiceEvent extends Equatable{
  const GetBpByServiceEvent();
  @override
  List<Object> get props => [];
}

class GetBpByServiceList extends GetBpByServiceEvent {
  int serviceId;
  GetBpByServiceList({ required this.serviceId });
}