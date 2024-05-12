import 'package:equatable/equatable.dart';


class DeleteNodeAccessEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartDeleteNodeAccess extends DeleteNodeAccessEvents {}

class DeleteAccessButtonPressed extends DeleteNodeAccessEvents{
  final int nodeAccessId;

  DeleteAccessButtonPressed({
    required this.nodeAccessId,
  });

}