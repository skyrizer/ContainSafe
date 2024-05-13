
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/rolePermission/delete/delRolePermission_bloc.dart';
import '../../bloc/rolePermission/delete/delRolePermission_event.dart';
import '../../bloc/rolePermission/get/getRolePermission_bloc.dart';
import '../../bloc/rolePermission/get/getRolePermission_event.dart';
import '../../bloc/rolePermission/get/getRolePermission_state.dart';

class ViewRolePermissionsScreen extends StatefulWidget {


  const ViewRolePermissionsScreen({Key? key}) : super(key: key);

  @override
  State<ViewRolePermissionsScreen> createState() => _ViewRolePermissionsScreenState();
}

class _ViewRolePermissionsScreenState extends State<ViewRolePermissionsScreen> {

  final GetAllRolePermissionBloc _rolePermissionListBloc = GetAllRolePermissionBloc();
  late DeleteRolePermissionBloc _deleteRolePermissionBloc;


  @override
  void initState() {

    _deleteRolePermissionBloc = BlocProvider.of<DeleteRolePermissionBloc>(context);
    _rolePermissionListBloc.add(GetAllRolePermissionList()); // Dispatch the event here
    super.initState();



  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _rolePermissionListBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('Role Permission', style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: _buildListRolePermission(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the page where you can add a new node
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => AddNodeConfigScreen()),
            // );
          },
          backgroundColor: HexColor("#3c1e08"),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildListRolePermission() {
    return Container(
      color: HexColor("#ecd9c9"),
      child: BlocBuilder<GetAllRolePermissionBloc, GetAllRolePermissionState>(
        builder: (context, state) {
          if (state is GetAllRolePermissionError) {
            return Center(
              child: Text(state.error ?? "Error loading data"),
            );
          } else if (state is GetAllRolePermissionInitial || state is GetAllRolePermissionLoading) {
            return Center(
              child: CircularProgressIndicator(color: HexColor("#3c1e08")),
            );
          } else if (state is GetAllRolePermissionLoaded) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(primary: HexColor("#3c1e08")),
              ),
              child: ListView.builder(
                itemCount: state.rolePermissionList.length,
                itemBuilder: (context, index) {
                  final rolePermissions = state.rolePermissionList[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rolePermissions.role.role!,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              rolePermissions.permission.name!,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            // Text(
                            //   nodeConfigs.value.toString() + " " + nodeConfigs.config.unit!,
                            //   style: TextStyle(
                            //     fontSize: 14.0,
                            //   ),
                            // ),
                          ],
                        ),
                        IconButton(
                          color: Colors.black,
                          onPressed: () {
                            // // Handle delete functionality here
                            _deleteRolePermissionBloc.add(DeleteRolePermissionButtonPressed(
                                roleId: rolePermissions.role.id!,
                                permissionId: rolePermissions.permission.id!
                            ));

                            setState(() {
                              BlocProvider.of<GetAllRolePermissionBloc>(context).add(GetAllRolePermissionList());

                            });

                          },
                          icon: Icon(Icons.delete, color: Colors.brown),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return SizedBox.shrink(); // Return an empty widget if none of the conditions match
        },
      ),
    );
  }


}
