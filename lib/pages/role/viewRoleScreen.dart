import 'package:containsafe/bloc/node/deleteNode/deleteNode_bloc.dart';
import 'package:containsafe/bloc/node/deleteNode/deleteNode_event.dart';
import 'package:containsafe/pages/nodeConfig/ViewNodeConfigScreen.dart';
import 'package:containsafe/pages/role/updateRoleScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/node/getAll/getAllNode_bloc.dart';
import '../../bloc/node/getAll/getAllNode_event.dart';
import '../../bloc/node/getAll/getAllNode_state.dart';
import '../../bloc/role/get/getRole_bloc.dart';
import '../../bloc/role/get/getRole_event.dart';
import '../../bloc/role/get/getRole_state.dart';
import 'addRoleScreen.dart';

class ViewRolesScreen extends StatefulWidget {
  const ViewRolesScreen({Key? key}) : super(key: key);

  @override
  State<ViewRolesScreen> createState() => _ViewRolesScreenState();
}

class _ViewRolesScreenState extends State<ViewRolesScreen> {

  final GetAllRoleBloc _roleListBloc = GetAllRoleBloc();
  // late DeleteNodeBloc _deleteNodeBloc;

  @override
  void initState() {
    super.initState();
    _roleListBloc.add(GetAllRoleList()); // Dispatch the event here
    // _deleteNodeBloc = BlocProvider.of<DeleteNodeBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _roleListBloc.add(GetAllRoleList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _roleListBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 8.0,
              ),
              Text('Roles', style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: _buildListRole(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the page where you can add a new node
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRoleScreen()),
            );
          },
          backgroundColor: HexColor("#3c1e08"),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildListRole() {
    return Container(
      color: HexColor("#ecd9c9"),
      child: BlocBuilder<GetAllRoleBloc, GetAllRoleState>(
        builder: (context, state) {
          if (state is GetAllRoleError) {
            return Center(
              child: Text(state.error ?? "Error loading data"),
            );
          } else if (state is GetAllRoleInitial || state is GetAllRoleLoading) {
            return Center(
              child: CircularProgressIndicator(color: HexColor("#3c1e08")),
            );
          } else if (state is GetAllRoleLoaded) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(primary: HexColor("#3c1e08")),
              ),
              child: ListView.builder(
                itemCount: state.roleList.length,
                itemBuilder: (context, index) {
                  final roles = state.roleList[index];
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
                              roles.role!,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        PopupMenuButton<int>(
                          onSelected: (value) {
                            if (value == 2) {
                              // Handle other action here
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UpdateRoleScreen(role: roles)),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.settings, color: Colors.brown),
                                  SizedBox(width: 8),
                                  Text('Setting'),
                                ],
                              ),
                            ),
                          ],
                          icon: Icon(Icons.more_vert, color: Colors.black),
                        )
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
