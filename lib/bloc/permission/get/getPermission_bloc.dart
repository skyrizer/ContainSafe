import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../model/permission/permission.dart';
import '../../../model/role/role.dart';
import '../../../repository/permission_repo.dart';
import '../../../repository/role_repo.dart';
import 'getPermission_event.dart';
import 'getPermission_state.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class GetAllPermissionBloc extends Bloc<GetAllPermissionEvent, GetAllPermissionState> {

  final PermissionRepository permissionRepository = PermissionRepository();

  GetAllPermissionBloc() : super(GetAllPermissionInitial()) {

    on<GetAllPermissionList>((event, emit) async {
      try {
        emit(GetAllPermissionLoading());
        final List<Permission> permissionList = await permissionRepository
            .getAllPermissions();
        emit(GetAllPermissionLoaded(permissionList: permissionList));

        if (permissionList[0].error != "") {
          emit(GetAllPermissionError(
              error: permissionList[0].error));
        }
      } on http.ClientException {
        emit(const GetAllPermissionError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
