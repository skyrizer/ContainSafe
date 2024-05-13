import 'package:equatable/equatable.dart';


class DeleteNodeConfigEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartDeleteNodeConfig extends DeleteNodeConfigEvents {}

class DeleteNodeConfigButtonPressed extends DeleteNodeConfigEvents{
  final int nodeId;
  final int configId;

  DeleteNodeConfigButtonPressed({
    required this.nodeId,
    required this.configId,

  });

}