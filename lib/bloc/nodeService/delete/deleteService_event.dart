import 'package:equatable/equatable.dart';


class DeleteNodeServiceEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartDeleteNodeService extends DeleteNodeServiceEvents {}

class DeleteServiceButtonPressed extends DeleteNodeServiceEvents{
  final int serviceId;
  final int nodeId;


  DeleteServiceButtonPressed({
    required this.serviceId,
    required this.nodeId,
  });

}