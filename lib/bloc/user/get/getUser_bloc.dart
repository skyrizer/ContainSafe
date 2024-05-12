import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../model/role/role.dart';
import '../../../model/user/user.dart';
import '../../../repository/role_repo.dart';
import '../../../repository/user_repo.dart';
import 'getUser_event.dart';
import 'getUser_state.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class GetAllUserBloc extends Bloc<GetAllUserEvent, GetAllUserState> {

  final UserRepository userRepository = UserRepository();

  GetAllUserBloc() : super(GetAllUserInitial()) {

    on<GetAllUserList>((event, emit) async {
      try {
        emit(GetAllUserLoading());
        final List<User> userList = await userRepository
            .getAllUsers();
        emit(GetAllUserLoaded(userList: userList));

        if (userList[0].error != "") {
          emit(GetAllUserError(
              error: userList[0].error));
        }
      } on http.ClientException {
        emit(const GetAllUserError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
