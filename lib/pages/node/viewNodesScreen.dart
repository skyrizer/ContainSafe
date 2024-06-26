import 'package:containsafe/pages/node/updateNodeScreen.dart';
import 'package:containsafe/pages/nodeService/ViewNodeServiceScreen.dart';
import 'package:flutter/material.dart';
import 'package:containsafe/model/node/node.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/node/deleteNode/deleteNode_bloc.dart';
import '../../bloc/node/deleteNode/deleteNode_event.dart';
import '../../bloc/node/getAll/getAllNode_bloc.dart';
import '../../bloc/node/getAll/getAllNode_event.dart';
import '../../bloc/node/getAll/getAllNode_state.dart';
import '../../repository/webSocket_repo.dart';
import '../ContainerPerformanceScreen.dart';
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
  bool _isMounted = false;
  int? roleId;


  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _nodeListBloc.add(GetAllNodeList());
    _deleteNodeBloc = BlocProvider.of<DeleteNodeBloc>(context);
    _getRoleId();
  }

  @override
  void dispose() {
    _isMounted = false;
    _nodeListBloc.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nodeListBloc.add(GetAllNodeList());
  }

  Future<void> _getRoleId() async {
    var pref = await SharedPreferences.getInstance(); // Await the future
    roleId = pref.getInt("roleId"); // Handle potential null value
  }

  Future<void> _checkNodeConnections() async {
    for (var node in nodeInfoList) {
      final isConnected = await _testNodeConnection(node.ipAddress);
      if (_isMounted) {
        setState(() {
          node.isConnected = isConnected;
        });
      }
    }
  }

  Future<bool> _testNodeConnection(String ipAddress) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("ipAddress", ipAddress);
    final webSocketRepository = WebSocketRepository('ws://$ipAddress:8765');
    final isConnected = await webSocketRepository.testConnection();
    return isConnected;
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
        floatingActionButton: roleId == 3 // Check if roleId is 3
            ? null // If roleId is 3, do not display FloatingActionButton
            : FloatingActionButton(
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
          } else if (state is GetAllNodeEmpty) {
            return Center(
              child: Text("There is no available node"),
            );
          } else if (state is GetAllNodeLoaded) {
            nodeInfoList = state.nodeList;
            _checkNodeConnections();  // Check connections when data is loaded
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
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => ContainerPerformanceScreen(node: nodes)),
                            );
                            } else if (value == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewNodeServiceScreen(node: nodes)),
                              );
                            } else if (value == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewNodeConfigsScreen(
                                        nodeId: nodes.id!)),
                              );
                            } else if (value == 4) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewNodeAccessesScreen(
                                            nodeId: nodes.id!)),
                              );
                            } else if (value == 5) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateNodeScreen(node: nodes)),
                              );
                            } else if (value == 6) {
                              _deleteNodeBloc
                                  .add(DeleteButtonPressed(nodeId: nodes.id!));
                              setState(() {
                                BlocProvider.of<GetAllNodeBloc>(context)
                                    .add(GetAllNodeList());
                              });
                            }
                          },
                          itemBuilder: (context) {
                            List<PopupMenuEntry<int>> items = [];
                            if (roleId == 3) {
                              items.add(
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(Icons.settings, color: Colors.brown),
                                      SizedBox(width: 8),
                                      Text('Monitor'),
                                    ],
                                  ),
                                ),
                              );
                              items.add(
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(Icons.settings, color: Colors.brown),
                                      SizedBox(width: 8),
                                      Text('Services'),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              items.add(
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(Icons.settings, color: Colors.brown),
                                      SizedBox(width: 8),
                                      Text('Monitor'),
                                    ],
                                  ),
                                ),
                              );
                              items.add(
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(Icons.settings, color: Colors.brown),
                                      SizedBox(width: 8),
                                      Text('Services'),
                                    ],
                                  ),
                                ),
                              );
                              items.add(
                                PopupMenuItem(
                                  value: 3,
                                  child: Row(
                                    children: [
                                      Icon(Icons.settings, color: Colors.brown),
                                      SizedBox(width: 8),
                                      Text('Setting'),
                                    ],
                                  ),
                                ),
                              );
                              items.add(
                                PopupMenuItem(
                                  value: 4,
                                  child: Row(
                                    children: [
                                      Icon(Icons.settings, color: Colors.brown),
                                      SizedBox(width: 8),
                                      Text('Access'),
                                    ],
                                  ),
                                ),
                              );
                              items.add(
                                PopupMenuItem(
                                  value: 5,
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.brown),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                              );
                              items.add(
                                PopupMenuItem(
                                  value: 6,
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.brown),
                                      SizedBox(width: 8),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return items;
                          },
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
