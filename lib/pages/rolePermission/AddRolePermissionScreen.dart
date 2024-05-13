
import 'package:containsafe/model/permission/permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/permission/get/getPermission_bloc.dart';
import '../../bloc/permission/get/getPermission_event.dart';
import '../../bloc/permission/get/getPermission_state.dart';
import '../../bloc/role/get/getRole_bloc.dart';
import '../../bloc/role/get/getRole_event.dart';
import '../../bloc/role/get/getRole_state.dart';
import '../../bloc/rolePermission/add/addRolePermission_bloc.dart';
import '../../bloc/rolePermission/add/addRolePermission_event.dart';
import '../../bloc/rolePermission/add/addRolePermission_state.dart';
import '../../model/role/role.dart';

class AddRolePermissionScreen extends StatefulWidget {
  const AddRolePermissionScreen({Key? key}) : super(key: key);

  @override
  State<AddRolePermissionScreen> createState() => _AddRolePermissionScreenState();
}

class _AddRolePermissionScreenState extends State<AddRolePermissionScreen> {

  final GetAllRoleBloc _getAllRoleBloc  = GetAllRoleBloc();
  final GetAllPermissionBloc _getAllPermissionBloc  = GetAllPermissionBloc();
  late AddRolePermissionBloc _addRolePermissionBloc;
  Role? _selectedRole; // Selected node
  Permission? _selectedPermission;


  TextEditingController valueController = TextEditingController();


  @override
  void initState() {
    _addRolePermissionBloc = BlocProvider.of<AddRolePermissionBloc>(context);
    _getAllRoleBloc.add(GetAllRoleList());
    _getAllPermissionBloc.add(GetAllPermissionList());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addRolePermissionBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Role Permission', style: Theme.of(context).textTheme.bodyText1),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<AddRolePermissionBloc, AddRolePermissionState>(
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(AddRolePermissionState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRoleDropdown(), // Dropdown to select nodes
          SizedBox(height: 16),
          _buildPermissionDropdown(),
          SizedBox(height: 16),
          saveButton(),
        ],
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return BlocProvider<GetAllRoleBloc>(
      create: (context) => _getAllRoleBloc, // Provide the instance of GetAllNodeBloc
      child: BlocBuilder<GetAllRoleBloc, GetAllRoleState>(
        builder: (context, state) {
          if (state is GetAllRoleLoaded) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child:
                  Text('Role'),

                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: DropdownButton<Role>(
                    hint: Text('Select Role'),
                    value: _selectedRole,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedRole = newValue; // Update selected node
                      });
                    },
                    items: _getRoleDropdownItems(state.roleList),
                    // Display the hostname for each item
                    // value will be the Node object itself
                  ),
                ),
              ],
            );
          } else {
            // Handle loading or error state
            return SizedBox.shrink(); // Or display an error message
          }
        },
      ),
    );
  }

  List<DropdownMenuItem<Role>> _getRoleDropdownItems(List<Role> roles) {
    return roles.map((role) {
      return DropdownMenuItem<Role>(
        value: role,
        child: Text(role.role!),
      );
    }).toList();
  }

  Widget _buildPermissionDropdown() {
    return BlocProvider<GetAllPermissionBloc>(
      create: (context) => _getAllPermissionBloc, // Provide the instance of GetAllNodeBloc
      child: BlocBuilder<GetAllPermissionBloc, GetAllPermissionState>(
        builder: (context, state) {
          if (state is GetAllPermissionLoaded) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child:  Text('Permission'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: DropdownButton<Permission>(
                    hint: Text('Select Permission'),
                    value: _selectedPermission,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedPermission = newValue; // Update selected node
                      });
                    },
                    items: _getPermissionDropdownItems(state.permissionList),
                  ),
                ),
              ],
            );
          } else {
            // Handle loading or error state
            return SizedBox.shrink(); // Or display an error message
          }
        },
      ),
    );
  }

  List<DropdownMenuItem<Permission>> _getPermissionDropdownItems(List<Permission> permission) {
    return permission.map((permission) {
      return DropdownMenuItem<Permission>(
        value: permission,
        child: Text(permission.name!),
      );
    }).toList();
  }



  Widget saveButton(){
    return Center(

      child: ElevatedButton(
        onPressed: () {
          // Dispatch an event to add node
          _addRolePermissionBloc.add(AddRolePermissionButtonPressed(
              roleId: _selectedRole!.id!,
              permissionId: _selectedPermission!.id!,
          ));
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.brown, // Change the background color here
        ),
        child: Text('Save'),
      ),
    );
  }


}
