import 'package:equatable/equatable.dart';


class AddPermissionEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartRegister extends AddPermissionEvents {}

class AddPermissionButtonPressed extends AddPermissionEvents {
  final String name;

  AddPermissionButtonPressed({
    required this.name,

  });
}

