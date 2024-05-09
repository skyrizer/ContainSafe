import 'package:equatable/equatable.dart';


class AddNodeConfigEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartRegister extends AddNodeConfigEvents {}

class AddNodeConfigButtonPressed extends AddNodeConfigEvents {

  final int configId;
  final int nodeId;
  final int value;


  AddNodeConfigButtonPressed({
    required this.configId,
    required this.nodeId,
    required this.value,
  });

}

