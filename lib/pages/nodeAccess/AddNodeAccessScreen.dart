
import 'package:containsafe/bloc/node/getAll/getAllNode_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/node/getAll/getAllNode_bloc.dart';
import '../../bloc/node/getAll/getAllNode_state.dart';
import '../../bloc/nodeAccess/add/addNodeAccess_bloc.dart';
import '../../bloc/nodeAccess/add/addNodeAccess_event.dart';
import '../../bloc/nodeAccess/add/addNodeAccess_state.dart';
import '../../bloc/role/get/getRole_bloc.dart';
import '../../bloc/role/get/getRole_event.dart';
import '../../bloc/role/get/getRole_state.dart';
import '../../bloc/user/get/getUser_bloc.dart';
import '../../bloc/user/get/getUser_event.dart';
import '../../bloc/user/get/getUser_state.dart';
import '../../model/node/node.dart';
import '../../model/role/role.dart';
import '../../model/user/user.dart';

class AddNodeAccessScreen extends StatefulWidget {
  const AddNodeAccessScreen({Key? key}) : super(key: key);

  @override
  State<AddNodeAccessScreen> createState() => _AddNodeAccessScreenState();
}

class _AddNodeAccessScreenState extends State<AddNodeAccessScreen> {

  final GetAllRoleBloc _getAllRoleBloc  = GetAllRoleBloc();
  final GetAllNodeBloc _getAllNodeBloc  = GetAllNodeBloc();
  final GetAllUserBloc _getAllUserBloc  = GetAllUserBloc();

  late AddNodeAccessBloc _addNodeAccessBloc;
  Node? _selectedNode; // Selected node
  Role? _selectedRole;
  User? _selectedUser;


  @override
  void initState() {

    _addNodeAccessBloc = BlocProvider.of<AddNodeAccessBloc>(context);

    _getAllNodeBloc .add(GetAllNodeList());
    _getAllUserBloc .add(GetAllUserList());
    _getAllRoleBloc .add(GetAllRoleList());

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addNodeAccessBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Node Access', style: Theme.of(context).textTheme.bodyText1),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<AddNodeAccessBloc, AddNodeAccessState>(
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(AddNodeAccessState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNodeDropdown(), // Dropdown to select nodes
          SizedBox(height: 16),
          _buildUserDropdown(),
          SizedBox(height: 16),
          _buildRoleDropdown(),
          SizedBox(height: 16),
          saveButton(),
        ],
      ),
    );
  }

  Widget _buildNodeDropdown() {
    return BlocProvider<GetAllNodeBloc>(
      create: (context) => _getAllNodeBloc, // Provide the instance of GetAllNodeBloc
      child: BlocBuilder<GetAllNodeBloc, GetAllNodeState>(
        builder: (context, state) {
          if (state is GetAllNodeLoaded) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child:
                  Text('Node'),

                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: DropdownButton<Node>(
                    hint: Text('Select Node'),
                    value: _selectedNode,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedNode = newValue; // Update selected node
                      });
                    },
                    items: _getNodeDropdownItems(state.nodeList),
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

  List<DropdownMenuItem<Node>> _getNodeDropdownItems(List<Node> nodes) {
    return nodes.map((node) {
      return DropdownMenuItem<Node>(
        value: node,
        child: Text(node.hostname),
      );
    }).toList();
  }

  Widget _buildUserDropdown() {
    return BlocProvider<GetAllUserBloc>(
      create: (context) => _getAllUserBloc, // Provide the instance of GetAllNodeBloc
      child: BlocBuilder<GetAllUserBloc, GetAllUserState>(
        builder: (context, state) {
          if (state is GetAllUserLoaded) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child:  Text('User'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: DropdownButton<User>(
                    hint: Text('Select User'),
                    value: _selectedUser,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedUser = newValue; // Update selected node
                      });
                    },
                    items: _getUserDropdownItems(state.userList),
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

  List<DropdownMenuItem<User>> _getUserDropdownItems(List<User> user) {
    return user.map((user) {
      return DropdownMenuItem<User>(
        value: user,
        child: Text(user.name!),
      );
    }).toList();
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
                  child:  Text('Role'),
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

  List<DropdownMenuItem<Role>> _getRoleDropdownItems(List<Role> role) {
    return role.map((role) {
      return DropdownMenuItem<Role>(
        value: role,
        child: Text(role.role!),
      );
    }).toList();
  }



  Widget saveButton(){
    return Center(

      child: ElevatedButton(
        onPressed: () {
          // Dispatch an event to add node
          _addNodeAccessBloc.add(AddNodeAccessButtonPressed(
              userId: _selectedUser!.id!,
              nodeId: _selectedNode!.id!,
              roleId: _selectedRole!.id!
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
