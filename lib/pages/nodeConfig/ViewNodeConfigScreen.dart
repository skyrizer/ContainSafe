import 'package:containsafe/bloc/node/deleteNode/deleteNode_bloc.dart';
import 'package:containsafe/bloc/node/deleteNode/deleteNode_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/node/getAll/getAllNode_bloc.dart';
import '../../bloc/node/getAll/getAllNode_event.dart';
import '../../bloc/node/getAll/getAllNode_state.dart';
import '../../bloc/nodeConfig/get/getNodeConfig_bloc.dart';
import '../../bloc/nodeConfig/get/getNodeConfig_event.dart';
import '../../bloc/nodeConfig/get/getNodeConfig_state.dart';
import '../node/addNodeScreen.dart';
import 'AddNodeConfigScreen.dart';

class ViewNodeConfigsScreen extends StatefulWidget {
  const ViewNodeConfigsScreen({Key? key}) : super(key: key);

  @override
  State<ViewNodeConfigsScreen> createState() => _ViewNodeConfigsScreenState();
}

class _ViewNodeConfigsScreenState extends State<ViewNodeConfigsScreen> {

  final GetAllNodeConfigBloc _nodeConfigListBloc = GetAllNodeConfigBloc();


  @override
  void initState() {
    super.initState();
    _nodeConfigListBloc.add(GetAllNodeConfigList()); // Dispatch the event here
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _nodeConfigListBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 8.0,
              ),
              Text('Nodes', style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: _buildListNode(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the page where you can add a new node
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNodeConfigScreen()),
            );
          },
          backgroundColor: HexColor("#3c1e08"),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildListNode() {
    return Container(
      color: HexColor("#ecd9c9"),
      child: BlocBuilder<GetAllNodeConfigBloc, GetAllNodeConfigState>(
        builder: (context, state) {
          if (state is GetAllNodeConfigError) {
            return Center(
              child: Text(state.error ?? "Error loading data"),
            );
          } else if (state is GetAllNodeConfigInitial || state is GetAllNodeConfigLoading) {
            return Center(
              child: CircularProgressIndicator(color: HexColor("#3c1e08")),
            );
          } else if (state is GetAllNodeConfigLoaded) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(primary: HexColor("#3c1e08")),
              ),
              child: ListView.builder(
                itemCount: state.nodeConfigList.length,
                itemBuilder: (context, index) {
                  final nodeConfigs = state.nodeConfigList[index];
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
                              nodeConfigs.node.hostname,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              nodeConfigs.config.name,
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              nodeConfigs.value.toString() + " " + nodeConfigs.config.unit,
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          color: Colors.black,
                          onPressed: () {
                            // // Handle delete functionality here
                            // _deleteNodeBloc.add(DeleteButtonPressed(nodeId: nodes.id));
                            //
                            // setState(() {
                            //   BlocProvider.of<GetAllNodeBloc>(context).add(GetAllNodeList());
                            //
                            // });

                          },
                          icon: Icon(Icons.edit, color: Colors.brown),
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
