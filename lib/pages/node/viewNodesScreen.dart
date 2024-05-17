import 'package:flutter/material.dart';
import 'package:containsafe/model/node/node.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/node/deleteNode/deleteNode_bloc.dart';
import '../../bloc/node/deleteNode/deleteNode_event.dart';
import '../../bloc/node/getAll/getAllNode_bloc.dart';
import '../../bloc/node/getAll/getAllNode_event.dart';
import '../../bloc/node/getAll/getAllNode_state.dart';
import '../../repository/webSocket_repo.dart';
import '../nodeAccess/ViewNodeAccessScreen.dart';
import '../nodeConfig/ViewNodeConfigScreen.dart';
import 'addNodeScreen.dart';

class ViewNodesScreen extends StatefulWidget {
  const ViewNodesScreen({Key? key}) : super(key: key);

  @override
  State<ViewNodesScreen> createState() => _ViewNodesScreenState();
}

class _ViewNodesScreenState extends State<ViewNodesScreen> {
  final GetAllNodeBloc _nodeListBloc = GetAllNodeBloc();
  late DeleteNodeBloc _deleteNodeBloc;
  List<Node> nodeInfoList = [];

  @override
  void initState() {
    super.initState();
    _nodeListBloc.add(GetAllNodeList());
    _deleteNodeBloc = BlocProvider.of<DeleteNodeBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nodeListBloc.add(GetAllNodeList());
  }

  Future<bool> _testNodeConnection(String ipAddress) async {
    final webSocketRepository =
        WebSocketRepository('ws://$ipAddress:8080');
    final isConnected = await webSocketRepository.testConnection();
    return isConnected;
  }

  Future<void> _checkNodeConnection(Node node) async {
    final isConnected = await _testNodeConnection(node.ipAddress);
    setState(() {
      node.isConnected = isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _nodeListBloc,
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNodeScreen()),
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
      child: BlocBuilder<GetAllNodeBloc, GetAllNodeState>(
        builder: (context, state) {
          if (state is GetAllNodeError) {
            return Center(
              child: Text(state.error ?? "Error loading data"),
            );
          } else if (state is GetAllNodeInitial || state is GetAllNodeLoading) {
            return Center(
              child: CircularProgressIndicator(color: HexColor("#3c1e08")),
            );
          } else if (state is GetAllNodeLoaded) {
            nodeInfoList = state.nodeList;
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(primary: HexColor("#3c1e08")),
              ),
              child: ListView.builder(
                itemCount: nodeInfoList.length,
                itemBuilder: (context, index) {
                  final nodes = nodeInfoList[index];
                  _checkNodeConnection(
                      nodes); // Check connection for each node individually
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
                              nodes.hostname,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              nodes.ipAddress,
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              nodes.isConnected! ? 'Alive' : 'Disconnected',
                              style: TextStyle(
                                color: nodes.isConnected!
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        PopupMenuButton<int>(
                          onSelected: (value) {
                            if (value == 1) {
                              _deleteNodeBloc
                                  .add(DeleteButtonPressed(nodeId: nodes.id!));
                              setState(() {
                                BlocProvider.of<GetAllNodeBloc>(context)
                                    .add(GetAllNodeList());
                              });
                            } else if (value == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewNodeConfigsScreen(
                                        nodeId: nodes.id!)),
                              );
                            } else if (value == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewNodeAccessesScreen(
                                            nodeId: nodes.id!)),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.brown),
                                  SizedBox(width: 8),
                                  Text('Delete'),
                                ],
                              ),
                            ),
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
                            PopupMenuItem(
                              value: 3,
                              child: Row(
                                children: [
                                  Icon(Icons.settings, color: Colors.brown),
                                  SizedBox(width: 8),
                                  Text('Access'),
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
          return SizedBox
              .shrink(); // Return an empty widget if none of the conditions match
        },
      ),
    );
  }
}
