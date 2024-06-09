import 'package:equatable/equatable.dart';


class RegisterEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartRegister extends RegisterEvents {}

class SignUpButtonPressed extends RegisterEvents {
  final String username;
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final int roleId;

  SignUpButtonPressed({
    required this.username,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.roleId,
  });
}

