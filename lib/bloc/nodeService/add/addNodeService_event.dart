import 'package:equatable/equatable.dart';


class AddNodeServiceEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartRegister extends AddNodeServiceEvents {}

class AddNodeServiceButtonPressed extends AddNodeServiceEvents {

  final int serviceId;
  final int nodeId;



  AddNodeServiceButtonPressed({
    required this.serviceId,
    required this.nodeId,
  });

}

