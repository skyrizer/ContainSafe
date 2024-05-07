import 'package:equatable/equatable.dart';


class DeleteNodeEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartDeleteNode extends DeleteNodeEvents {}

class DeleteButtonPressed extends DeleteNodeEvents{
  final int nodeId;

  DeleteButtonPressed({
    required this.nodeId,
  });

}