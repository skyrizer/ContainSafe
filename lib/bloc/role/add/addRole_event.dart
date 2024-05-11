import 'package:equatable/equatable.dart';


class AddRoleEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartRegister extends AddRoleEvents {}

class AddRoleButtonPressed extends AddRoleEvents {
  final String role;

  AddRoleButtonPressed({
    required this.role,

  });
}

