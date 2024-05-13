import 'package:containsafe/model/rolePermission/rolePermission.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../repository/rolePermission_repo.dart';
import 'getRolePermission_event.dart';
import 'getRolePermission_state.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class GetAllRolePermissionBloc extends Bloc<GetAllRolePermissionEvent, GetAllRolePermissionState> {

  final RolePermissionRepository rolePermissionRepository = RolePermissionRepository();

  GetAllRolePermissionBloc() : super(GetAllRolePermissionInitial()) {

    on<GetAllRolePermissionList>((event, emit) async {
      try {
        emit(GetAllRolePermissionLoading());
        final List<RolePermission> rolePermissionList = await rolePermissionRepository
            .getAllRolePermissions();
        emit(GetAllRolePermissionLoaded(rolePermissionList: rolePermissionList));

        if (rolePermissionList[0].error != "") {
          emit(GetAllRolePermissionError(
              error: rolePermissionList[0].error));
        }
      } on http.ClientException {
        emit(const GetAllRolePermissionError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
