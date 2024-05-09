import 'package:equatable/equatable.dart';


class GetConfigByNodeEvent extends Equatable{
  const GetConfigByNodeEvent();
  @override
  List<Object> get props => [];
}

class GetConfigByNodeList extends GetConfigByNodeEvent {
  int nodeId;
  GetConfigByNodeList({ required this.nodeId });
}