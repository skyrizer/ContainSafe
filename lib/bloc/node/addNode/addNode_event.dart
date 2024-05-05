import 'package:equatable/equatable.dart';


class AddNodeEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartRegister extends AddNodeEvents {}

class AddNodeButtonPressed extends AddNodeEvents {
  final String hostname;
  final String ipAddress;


  AddNodeButtonPressed({
    required this.hostname,
    required this.ipAddress,

  });
}

