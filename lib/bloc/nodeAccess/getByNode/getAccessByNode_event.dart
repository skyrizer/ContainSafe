import 'package:equatable/equatable.dart';


class GetAccessByNodeEvent extends Equatable{
  const GetAccessByNodeEvent();
  @override
  List<Object> get props => [];
}

class GetAccessByNodeList extends GetAccessByNodeEvent {
  int nodeId;
  GetAccessByNodeList({ required this.nodeId });
}