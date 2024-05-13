import 'package:equatable/equatable.dart';


class DeleteNodeAccessEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartDeleteNodeAccess extends DeleteNodeAccessEvents {}

class DeleteAccessButtonPressed extends DeleteNodeAccessEvents{
  final int nodeId;
  final int userId;
  final int roleId;


  DeleteAccessButtonPressed({
    required this.nodeId,
    required this.userId,
    required this.roleId,
  });

}