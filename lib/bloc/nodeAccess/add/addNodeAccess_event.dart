import 'package:equatable/equatable.dart';


class AddNodeAccessEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartRegister extends AddNodeAccessEvents {}

class AddNodeAccessButtonPressed extends AddNodeAccessEvents {

  final int userId;
  final int nodeId;
  final int roleId;


  AddNodeAccessButtonPressed({
    required this.userId,
    required this.nodeId,
    required this.roleId,
  });

}

