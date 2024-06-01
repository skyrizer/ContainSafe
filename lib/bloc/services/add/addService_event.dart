import 'package:equatable/equatable.dart';


class AddServiceEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartRegister extends AddServiceEvents {}

class AddServiceButtonPressed extends AddServiceEvents {
  final String name;

  AddServiceButtonPressed({
    required this.name,
  });
}

