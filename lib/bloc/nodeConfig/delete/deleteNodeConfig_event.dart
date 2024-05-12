import 'package:equatable/equatable.dart';


class DeleteNodeConfigEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartDeleteNodeConfig extends DeleteNodeConfigEvents {}

class DeleteNodeConfigButtonPressed extends DeleteNodeConfigEvents{
  final int nodeConfigId;

  DeleteNodeConfigButtonPressed({
    required this.nodeConfigId,
  });

}