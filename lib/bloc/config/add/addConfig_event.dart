import 'package:equatable/equatable.dart';


class AddConfigEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartRegisterNodeConfig extends AddConfigEvents {}

class AddConfigButtonPressed extends AddConfigEvents {
  final String name;
  final String unit;


  AddConfigButtonPressed({
    required this.name,
    required this.unit,

  });
}

