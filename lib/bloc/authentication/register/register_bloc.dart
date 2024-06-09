import 'package:containsafe/bloc/authentication/register/register_event.dart';
import 'package:containsafe/bloc/authentication/register/register_state.dart';
import 'package:containsafe/repository/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvents, RegisterState>{
  AuthRepository repo;
  RegisterBloc(RegisterState initialState, this.repo): super(initialState){
    on<StartRegister>((event,emit){
      emit(RegisterInitState());
    });

    on<SignUpButtonPressed>((event,emit) async{
      emit(RegisterLoadingState());
      int validSignUp = await repo.register(
          event.username,event.name,event.email, event.password,
          event.confirmPassword, event.phoneNumber, event.roleId);
      if (validSignUp == 0){
        emit(RegisterSuccessState());
      } else if (validSignUp == 1){
        emit(UsernameFailState());
      } else if (validSignUp == 2){
        emit(EmailFailState());
      } else if (validSignUp == 3){
        emit(RegisterFailState(message: 'Network connection. Please try again.'));
      }
    });
  }
}