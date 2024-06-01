import 'package:equatable/equatable.dart';


class AddBpEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartRegister extends AddBpEvents {}

class AddBpButtonPressed extends AddBpEvents {
  final String name;
  final int serviceId;


  AddBpButtonPressed({
    required this.name,
    required this.serviceId,

  });
}

