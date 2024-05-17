import 'package:containsafe/bloc/nodeAccess/delete/deleteAccess_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/nodeAccess/delete/deleteAccess_event.dart';
import '../../bloc/nodeAccess/getByNode/getAccessByNode_bloc.dart';
import '../../bloc/nodeAccess/getByNode/getAccessByNode_event.dart';
import '../../bloc/nodeAccess/getByNode/getAccessByNode_state.dart';
import '../../bloc/nodeConfig/getByNode/getConfigByNode_bloc.dart';
import '../../bloc/nodeConfig/getByNode/getConfigByNode_event.dart';
import '../../bloc/nodeConfig/getByNode/getConfigByNode_state.dart';
import 'AddNodeAccessScreen.dart';

class ViewNodeAccessesScreen extends StatefulWidget {
  final int nodeId;

  const ViewNodeAccessesScreen({Key? key, required this.nodeId})
      : super(key: key);

  @override
  State<ViewNodeAccessesScreen> createState() => _ViewNodeAccessesScreenState();
}

class _ViewNodeAccessesScreenState extends State<ViewNodeAccessesScreen> {
  final GetAccessByNodeBloc _nodeAccessListBloc = GetAccessByNodeBloc();
  late DeleteNodeAccessBloc _deleteNodeAccessBloc;

  @override
  void initState() {
    super.initState();
    _nodeAccessListBloc.add(
        GetAccessByNodeList(nodeId: widget.nodeId)); // Dispatch the event here
    _deleteNodeAccessBloc = BlocProvider.of<DeleteNodeAccessBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _nodeAccessListBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('Accesses', style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: _buildListNodeAccess(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the page where you can add a new node
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNodeAccessScreen()),
            );
          },
          backgroundColor: HexColor("#3c1e08"),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildListNodeAccess() {
    return Container(
      color: HexColor("#ecd9c9"),
      child: BlocBuilder<GetAccessByNodeBloc, GetAccessByNodeState>(
        builder: (context, state) {
          if (state is GetAccessByNodeError) {
            return Center(
              child: Text(state.error ?? "Error loading data"),
            );
          } else if (state is GetAccessByNodeInitial ||
              state is GetAccessByNodeLoading) {
            return Center(
              child: CircularProgressIndicator(color: HexColor("#3c1e08")),
            );
          } else if (state is GetAccessByNodeLoaded) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(primary: HexColor("#3c1e08")),
              ),
              child: ListView.builder(
                itemCount: state.nodeAccessList.length,
                itemBuilder: (context, index) {
                  final nodeAccesses = state.nodeAccessList[index];
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                              nodeAccesses.user.username,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              nodeAccesses.user.email!,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              nodeAccesses.role.role!,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // SizedBox(height: 10.0),
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
                            _deleteNodeAccessBloc.add(DeleteAccessButtonPressed(
                              
                                nodeId: nodeAccesses.node.id!,
                                userId: nodeAccesses.user.id,
                                roleId: nodeAccesses.role.id!));

                            setState(() {
                              BlocProvider.of<GetAccessByNodeBloc>(context).add(
                                  GetAccessByNodeList(nodeId: widget.nodeId));
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
          return SizedBox
              .shrink(); // Return an empty widget if none of the conditions match
        },
      ),
    );
  }
}
