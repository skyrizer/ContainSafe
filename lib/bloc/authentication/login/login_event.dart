import 'package:equatable/equatable.dart';

class AuthEvents extends Equatable{
  @override
  // getter method that return a list
  List<Object> get props => [];
}

class StartEvent extends AuthEvents {}

class LoginButtonPressed extends AuthEvents{
  // define the DTO needed
  final String email;
  final String password;

  // constructor
  LoginButtonPressed({required this.email, required this.password});
}

class EmptyField extends AuthEvents{}

class GetRefreshToken extends AuthEvents{}

class GetLogin extends AuthEvents{}