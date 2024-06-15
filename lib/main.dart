import 'package:containsafe/bloc/backgroundProcess/getByService/getBpService_bloc.dart';
import 'package:containsafe/bloc/container/get/getContainer_bloc.dart';
import 'package:containsafe/bloc/node/addNode/addNode_bloc.dart';
import 'package:containsafe/bloc/rolePermission/get/getRolePermission_bloc.dart';
import 'package:containsafe/repository/backgroundProcess_repo.dart';
import 'package:containsafe/repository/config_repo.dart';
import 'package:containsafe/repository/container_repo.dart';
import 'package:containsafe/repository/httpResponse_repo.dart';
import 'package:containsafe/repository/nodeAccess_repo.dart';
import 'package:containsafe/repository/nodeConfig_repo.dart';
import 'package:containsafe/repository/nodeService_repo.dart';
import 'package:containsafe/repository/node_repo.dart';
import 'package:containsafe/repository/permission_repo.dart';
import 'package:containsafe/repository/rolePermission_repo.dart';
import 'package:containsafe/repository/role_repo.dart';
import 'package:containsafe/repository/service_repo.dart';
import 'package:containsafe/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:containsafe/pages/splashScreen.dart';
import 'package:containsafe/bloc/authentication/login/login_bloc.dart';
import 'package:containsafe/bloc/authentication/login/login_state.dart';
import 'package:containsafe/repository/auth_repo.dart';
import 'bloc/authentication/logout/logout_bloc.dart';
import 'bloc/authentication/logout/logout_state.dart';
import 'bloc/authentication/register/register_bloc.dart';
import 'bloc/authentication/register/register_state.dart';
import 'bloc/backgroundProcess/add/addBp_bloc.dart';
import 'bloc/backgroundProcess/add/addBp_state.dart';
import 'bloc/config/add/addConfig_bloc.dart';
import 'bloc/config/add/addConfig_state.dart';
import 'bloc/config/get/getConfig_bloc.dart';
import 'bloc/config/update/editConfig_bloc.dart';
import 'bloc/config/update/editConfig_state.dart';
import 'bloc/container/get/getContainer_state.dart';
import 'bloc/container/performance/performance_bloc.dart';
import 'bloc/container/performanceWS/performanceWS_bloc.dart';
import 'bloc/httpResponse/httpResponse_bloc.dart';
import 'bloc/httpResponse/searchByDate/searchByDate_bloc.dart';
import 'bloc/httpResponse/searchByDate/searchByDate_state.dart';
import 'bloc/httpResponse/searchByNode/searchByCode_bloc.dart';
import 'bloc/httpResponse/searchByNode/searchByCode_state.dart';
import 'bloc/node/addNode/addNode_state.dart';
import 'bloc/node/deleteNode/deleteNode_bloc.dart';
import 'bloc/node/deleteNode/deleteNode_state.dart';
import 'bloc/node/getAll/getAllNode_bloc.dart';
import 'bloc/node/update/updateNode_bloc.dart';
import 'bloc/node/update/updateNode_state.dart';
import 'bloc/nodeAccess/add/addNodeAccess_bloc.dart';
import 'bloc/nodeAccess/add/addNodeAccess_state.dart';
import 'bloc/nodeAccess/delete/deleteAccess_bloc.dart';
import 'bloc/nodeAccess/delete/deleteAccess_state.dart';
import 'bloc/nodeAccess/getByNode/getAccessByNode_bloc.dart';
import 'bloc/nodeConfig/add/addNodeConfig_bloc.dart';
import 'bloc/nodeConfig/add/addNodeConfig_state.dart';
import 'bloc/nodeConfig/delete/deleteNodeConfig_bloc.dart';
import 'bloc/nodeConfig/delete/deleteNodeConfig_state.dart';
import 'bloc/nodeConfig/get/getNodeConfig_bloc.dart';
import 'bloc/nodeConfig/getByNode/getConfigByNode_bloc.dart';
import 'bloc/nodeService/add/addNodeService_bloc.dart';
import 'bloc/nodeService/add/addNodeService_state.dart';
import 'bloc/nodeService/delete/deleteService_bloc.dart';
import 'bloc/nodeService/delete/deleteService_state.dart';
import 'bloc/permission/add/addPermission_bloc.dart';
import 'bloc/permission/add/addPermission_state.dart';
import 'bloc/permission/edit/editPermission_bloc.dart';
import 'bloc/permission/edit/editPermission_state.dart';
import 'bloc/permission/get/getPermission_bloc.dart';
import 'bloc/role/add/addRole_bloc.dart';
import 'bloc/role/add/addRole_state.dart';
import 'bloc/role/edit/editRole_bloc.dart';
import 'bloc/role/edit/editRole_state.dart';
import 'bloc/role/get/getRole_bloc.dart';
import 'bloc/rolePermission/add/addRolePermission_bloc.dart';
import 'bloc/rolePermission/add/addRolePermission_state.dart';
import 'bloc/rolePermission/delete/delRolePermission_bloc.dart';
import 'bloc/rolePermission/delete/delRolePermission_state.dart';
import 'bloc/services/add/addService_bloc.dart';
import 'bloc/services/add/addService_state.dart';
import 'bloc/services/get/getServices_bloc.dart';
import 'bloc/services/getByNode/getNodeServices_bloc.dart';
import 'bloc/user/get/getUser_bloc.dart';
import 'bloc/user/search/searchUser_bloc.dart';
import 'bloc/user/search/searchUser_state.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.initialize("2c9ce8b1-a075-4864-83a3-009c8497310e");
  OneSignal.Notifications.requestPermission(true);
  OneSignal.Notifications.addPermissionObserver((state) {
    print("Has permission " + state.toString());
  });

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const title = 'ContainSafe';
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(LoginInitState(), AuthRepository()),
        ),
        BlocProvider<LogoutBloc>(
          create: (context) => LogoutBloc(LogoutInitState(), AuthRepository()),
        ),
        BlocProvider<PerformanceWSBloc>(
          create: (context) => PerformanceWSBloc(),
        ),
        BlocProvider<PerformanceBloc>(
          create: (context) => PerformanceBloc(),
        ),
        BlocProvider<GetAllNodeBloc>(
          create: (context) => GetAllNodeBloc(),
        ),
        BlocProvider<GetAllNodeConfigBloc>(
          create: (context) => GetAllNodeConfigBloc(),
        ),
        BlocProvider<GetAllConfigBloc>(
          create: (context) => GetAllConfigBloc(),
        ),
        BlocProvider<GetAllRoleBloc>(
          create: (context) => GetAllRoleBloc(),
        ),
        BlocProvider<GetAllPermissionBloc>(
          create: (context) => GetAllPermissionBloc(),
        ),
        BlocProvider<GetAllUserBloc>(
          create: (context) => GetAllUserBloc(),
        ),
        BlocProvider<GetAllRolePermissionBloc>(
          create: (context) => GetAllRolePermissionBloc(),
        ),
        BlocProvider<GetAllServiceBloc>(
          create: (context) => GetAllServiceBloc(),
        ),
        BlocProvider<GetNodeServicesBloc>(
          create: (context) => GetNodeServicesBloc(),
        ),
        BlocProvider<GetConfigByNodeBloc>(
          create: (context) => GetConfigByNodeBloc(),
        ),
        BlocProvider<GetAccessByNodeBloc>(
          create: (context) => GetAccessByNodeBloc(),
        ),
        BlocProvider<GetBpByServiceBloc>(
          create: (context) => GetBpByServiceBloc(),
        ),
        BlocProvider<GetHttpResponsesBloc>(
          create: (context) => GetHttpResponsesBloc(),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(RegisterState(), AuthRepository()),
        ),
        BlocProvider<AddNodeBloc>(
          create: (context) => AddNodeBloc(AddNodeState(), NodeRepository()),
        ),
        BlocProvider<AddRoleBloc>(
          create: (context) => AddRoleBloc(AddRoleState(), RoleRepository()),
        ),
        BlocProvider<AddConfigBloc>(
          create: (context) => AddConfigBloc(AddConfigState(), ConfigRepository()),
        ),
        BlocProvider<AddNodeConfigBloc>(
          create: (context) => AddNodeConfigBloc(AddNodeConfigState(), NodeConfigRepository()),
        ),
        BlocProvider<AddPermissionBloc>(
          create: (context) => AddPermissionBloc(AddPermissionState(), PermissionRepository()),
        ),
        BlocProvider<AddNodeAccessBloc>(
          create: (context) => AddNodeAccessBloc(AddNodeAccessState(), NodeAccessRepository()),
        ),
        BlocProvider<AddNodeServiceBloc>(
          create: (context) => AddNodeServiceBloc(AddNodeServiceState(), NodeServiceRepository()),
        ),
        BlocProvider<AddRolePermissionBloc>(
          create: (context) => AddRolePermissionBloc(AddRolePermissionState(), RolePermissionRepository()),
        ),
        BlocProvider<AddServiceBloc>(
          create: (context) => AddServiceBloc(AddServiceState(), ServiceRepository()),
        ),
        BlocProvider<AddBpBloc>(
          create: (context) => AddBpBloc(AddBpState(), BackgroundProcessRepository()),
        ),
        BlocProvider<EditConfigBloc>(
          create: (context) => EditConfigBloc(EditConfigState(), ConfigRepository()),
        ),
        BlocProvider<EditNodeBloc>(
          create: (context) => EditNodeBloc(EditNodeState(), NodeRepository()),
        ),
        BlocProvider<EditRoleBloc>(
          create: (context) => EditRoleBloc(EditRoleState(), RoleRepository()),
        ),
        BlocProvider<EditPermissionBloc>(
          create: (context) => EditPermissionBloc(EditPermissionState(), PermissionRepository()),
        ),
        BlocProvider<GetContainerBloc>(
          create: (context) => GetContainerBloc(GetContainerState(), ContainerRepository()),
        ),
        BlocProvider<DeleteNodeBloc>(
          create: (context) => DeleteNodeBloc(DeleteNodeState(), NodeRepository()),
        ),
        BlocProvider<DeleteNodeConfigBloc>(
          create: (context) => DeleteNodeConfigBloc(DeleteNodeConfigState(), NodeConfigRepository()),
        ),
        BlocProvider<DeleteNodeAccessBloc>(
          create: (context) => DeleteNodeAccessBloc(DeleteNodeAccessState(), NodeAccessRepository()),
        ),
        BlocProvider<DeleteRolePermissionBloc>(
          create: (context) => DeleteRolePermissionBloc(DeleteRolePermissionState(), RolePermissionRepository()),
        ),
        BlocProvider<DeleteNodeServiceBloc>(
          create: (context) => DeleteNodeServiceBloc(DeleteNodeServiceState(), NodeServiceRepository()),
        ),
        BlocProvider<SearchByCodeBloc>(
          create: (context) => SearchByCodeBloc(SearchByCodeState(), HttpResponseRepository()),
        ),
        BlocProvider<SearchByDateBloc>(
          create: (context) => SearchByDateBloc(SearchByDateState(), HttpResponseRepository()),
        ),
        BlocProvider<SearchUserBloc>(
          create: (context) => SearchUserBloc(SearchUserState(), UserRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
            scaffoldBackgroundColor: HexColor("#ecd9c9"),
            fontFamily: 'Times New Roman',
            textTheme: TextTheme(
                bodyMedium: TextStyle(
                  color: HexColor("#3c1e08"),
                  fontSize: 13,
                ),
                bodyLarge: TextStyle(
                  color: HexColor("#3c1e08"),
                  fontSize: 23,
                )
            ),
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: HexColor('#3c1e08')),
              color: HexColor('#3c1e08'),
            )
        ),
        home:Splash(),
      ),
    );
  }
}

