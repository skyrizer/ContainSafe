import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../model/role/role.dart';
import '../../../repository/node_repo.dart';
import '../../../repository/role_repo.dart';
import '/../model/node/node.dart';
import 'getRole_event.dart';
import 'getRole_state.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class GetAllRoleBloc extends Bloc<GetAllRoleEvent, GetAllRoleState> {

  final RoleRepository roleRepository = RoleRepository();

  GetAllRoleBloc() : super(GetAllRoleInitial()) {

    on<GetAllRoleList>((event, emit) async {
      try {
        emit(GetAllRoleLoading());
        final List<Role> roleList = await roleRepository
            .getAllRoles();
        emit(GetAllRoleLoaded(roleList: roleList));

        if (roleList[0].error != "") {
          emit(GetAllRoleError(
              error: roleList[0].error));
        }
      } on http.ClientException {
        emit(const GetAllRoleError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
