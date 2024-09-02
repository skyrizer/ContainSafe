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
import '../../bloc/user/search/searchUser_bloc.dart';
import '../../bloc/user/search/searchUser_event.dart';
import '../../bloc/user/search/searchUser_state.dart';
import '../../model/node/node.dart';
import '../../model/role/role.dart';
import '../../model/user/user.dart';

class AddNodeAccessScreen extends StatefulWidget {
  const AddNodeAccessScreen({Key? key}) : super(key: key);

  @override
  State<AddNodeAccessScreen> createState() => _AddNodeAccessScreenState();
}

class _AddNodeAccessScreenState extends State<AddNodeAccessScreen> {
  TextEditingController nameController = TextEditingController();
  List<User> userlist = [];
  late SearchUserBloc searchUserBloc;

  final GetAllRoleBloc _getAllRoleBloc = GetAllRoleBloc();
  final GetAllNodeBloc _getAllNodeBloc = GetAllNodeBloc();
  final GetAllUserBloc _getAllUserBloc = GetAllUserBloc();

  late AddNodeAccessBloc _addNodeAccessBloc;
  Node? _selectedNode; // Selected node
  Role? _selectedRole;
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    _addNodeAccessBloc = BlocProvider.of<AddNodeAccessBloc>(context);
    searchUserBloc = BlocProvider.of<SearchUserBloc>(context);

    _getAllNodeBloc.add(GetAllNodeList());
    _getAllUserBloc.add(GetAllUserList());
    _getAllRoleBloc.add(GetAllRoleList());
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
          userNameField(),
          BlocBuilder<SearchUserBloc, SearchUserState>(
            builder: (context, state) {
              if (state is SearchUserLoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: HexColor("#3c1e08"),
                  ),
                );
              } else if (state is SearchUserLoadedState) {
                userlist = state.userList;
                return _resultList();
              } else if (state is SearchUserErrorState) {
                return Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                );
              } else if (state is SearchUserEmptyState){
                return Center(
                  child: Text( "No user found",
                  ),
                );
              }
              else {
                return Container();
              }
            },
          ),
          SizedBox(height: 16),
          _buildNodeDropdown(), // Dropdown to select nodes
          SizedBox(height: 16),
          _buildRoleDropdown(),
          SizedBox(height: 16),
          saveButton(),
        ],
      ),
    );
  }

  Widget userNameField() {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      width: 270,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text("User:"),
            SizedBox(width: 8.0), // Adjusted spacing
            Expanded(
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter user name",
                  filled: true,
                  fillColor: HexColor("#ecd9c9"), // Change field color based on focus
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none, // Remove the border
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                ),
                cursorColor: HexColor("#3c1e08"), // Change the cursor color
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    searchUserBloc.add(SearchUserPressed(name: text.trim()));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultList() {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: userlist.length,
        itemBuilder: (context, index) {
          User user = userlist[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedUser = user;
                nameController.text = user.name!;
                userlist.clear();
              });
            },
            child: Center(
              child: Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${user.name}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Username: ${user.username}',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Email: ${user.email}',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
                  child: Text('Node'),
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
                  child: Text('Role'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: DropdownButton<Role>(
                    hint: Text('Select Role'),
                    value: _selectedRole,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedRole = newValue; // Update selected role
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

  List<DropdownMenuItem<Role>> _getRoleDropdownItems(List<Role> roles) {
    return roles.map((role) {
      return DropdownMenuItem<Role>(
        value: role,
        child: Text(role.role!),
      );
    }).toList();
  }

  Widget saveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (_selectedUser != null && _selectedNode != null && _selectedRole != null) {
            // Dispatch an event to add node
            _addNodeAccessBloc.add(AddNodeAccessButtonPressed(
              userId: _selectedUser!.id!,
              nodeId: _selectedNode!.id!,
              roleId: _selectedRole!.id!,
            ));
          } else {
            // Show an error message if not all fields are selected
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please select a user, node, and role.'),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.brown, // Change the background color here
        ),
        child: Text('Save'),
      ),
    );
  }
}
