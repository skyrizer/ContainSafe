
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/permission/get/getPermission_bloc.dart';
import '../../bloc/permission/get/getPermission_event.dart';
import '../../bloc/permission/get/getPermission_state.dart';

class ViewPermissionsScreen extends StatefulWidget {
  const ViewPermissionsScreen({Key? key}) : super(key: key);

  @override
  State<ViewPermissionsScreen> createState() => _ViewPermissionsScreenState();
}

class _ViewPermissionsScreenState extends State<ViewPermissionsScreen> {

  final GetAllPermissionBloc _permissionListBloc = GetAllPermissionBloc();
  // late DeleteNodeBloc _deleteNodeBloc;

  @override
  void initState() {
    super.initState();
    _permissionListBloc.add(GetAllPermissionList()); // Dispatch the event here
    // _deleteNodeBloc = BlocProvider.of<DeleteNodeBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _permissionListBloc.add(GetAllPermissionList()); // Dispatch the event here
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _permissionListBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(width: 8.0,),
              Text('Permissions', style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: _buildListPermission(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the page where you can add a new node
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => AddNodeScreen()),
            // );
          },
          backgroundColor: HexColor("#3c1e08"),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildListPermission() {
    return Container(
      color: HexColor("#ecd9c9"),
      child: BlocBuilder<GetAllPermissionBloc, GetAllPermissionState>(
        builder: (context, state) {
          if (state is GetAllPermissionError) {
            return Center(
              child: Text(state.error ?? "Error loading data"),
            );
          } else if (state is GetAllPermissionInitial || state is GetAllPermissionLoading) {
            return Center(
              child: CircularProgressIndicator(color: HexColor("#3c1e08")),
            );
          } else if (state is GetAllPermissionLoaded) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(primary: HexColor("#3c1e08")),
              ),
              child: ListView.builder(
                itemCount: state.permissionList.length,
                itemBuilder: (context, index) {
                  final permissions = state.permissionList[index];
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
                              permissions.name!,
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
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => ViewNodeConfigsScreen(nodeId: nodes.id)),
                              // );
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
