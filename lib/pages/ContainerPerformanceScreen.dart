import 'package:containsafe/bloc/nodeConfig/get/getNodeConfig_event.dart';
import 'package:containsafe/repository/APIConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../bloc/container/performanceWS/performanceWS_bloc.dart';
import '../bloc/container/performanceWS/performanceWS_event.dart';
import '../bloc/container/performanceWS/performanceWS_state.dart';
import '../bloc/node/getAll/getAllNode_bloc.dart';
import '../bloc/node/getAll/getAllNode_event.dart';
import '../bloc/node/getAll/getAllNode_state.dart';
import '../bloc/nodeConfig/get/getNodeConfig_bloc.dart';
import '../bloc/nodeConfig/getByNode/getConfigByNode_bloc.dart';
import '../bloc/nodeConfig/getByNode/getConfigByNode_event.dart';
import '../bloc/nodeConfig/getByNode/getConfigByNode_state.dart';
import '../model/node/node.dart';
import '../model/nodeConfig/nodeConfig.dart';
import '../repository/webSocket_repo.dart';
import 'container/updateContainerScreen.dart';

class ContainerPerformanceScreen extends StatefulWidget {
  final Node node;
  const ContainerPerformanceScreen({super.key, required this.node});

  @override
  State<ContainerPerformanceScreen> createState() => _ContainerPerformanceScreenState();
}

class _ContainerPerformanceScreenState extends State<ContainerPerformanceScreen> {
  late PerformanceWSBloc _performanceWSBloc;
  final GetAllNodeBloc _allNodeBloc = GetAllNodeBloc();
  final GetConfigByNodeBloc _nodeConfigBloc = GetConfigByNodeBloc();

  Node? _selectedNode;
  List<NodeConfig> _nodeConfigList = [];

  @override
  void initState() {
    super.initState();
    _allNodeBloc.add(GetAllNodeList());
    _nodeConfigBloc.add(GetConfigByNodeList(nodeId: widget.node.id!));
    _performanceWSBloc = PerformanceWSBloc()..add(LoadPerformanceWSData(widget.node.ipAddress));

  }

  @override
  void dispose() {
    _performanceWSBloc.close();
    super.dispose();
  }


  void _sendMessage(String message) async {
    final webSocketRepository = WebSocketRepository('ws://${widget.node.ipAddress}:8765');
    webSocketRepository.sendSleepDuration(int.parse(message));

  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetAllNodeBloc>(
          create: (context) => _allNodeBloc,
        ),
        BlocProvider<GetConfigByNodeBloc>(
          create: (context) => _nodeConfigBloc,
        ),
        BlocProvider<PerformanceWSBloc>(
          create: (context) => _performanceWSBloc,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('Container', style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            BlocBuilder<GetConfigByNodeBloc, GetConfigByNodeState>(
              builder: (context, state) {
                if (state is GetConfigByNodeLoading) {
                  return SizedBox.shrink();
                } else if (state is GetConfigByNodeError) {
                  return Center(child: Text('Failed to load node configuration'));
                } else if (state is GetConfigByNodeEmpty) {
                  return Center(child: Text('No configuration available for this node'));
                } else if (state is GetConfigByNodeLoaded) {
                  _nodeConfigList = state.nodeConfigList;
                  _nodeConfigList.forEach((config) {
                    if (config.configId == 1) {
                      _sendMessage(config.value.toString());
                    }
                  });
                  return SizedBox.shrink();
                }
                return SizedBox.shrink();
              },
            ),
            Expanded(
              child: BlocBuilder<PerformanceWSBloc, PerformanceWSState>(
                builder: (context, state) {
                  return _buildContent(state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildContent(PerformanceWSState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       // _buildDropdown(),
        SizedBox(height: 16),
        Expanded(
          child: _buildListPerformance(state),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return BlocBuilder<GetAllNodeBloc, GetAllNodeState>(
      builder: (context, state) {
        if (state is GetAllNodeLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: DropdownButton<Node>(
              hint: Text('Select Node'),
              value: _selectedNode,
              onChanged: (newValue) {
                setState(() {
                  _selectedNode = newValue;
                  _performanceWSBloc.add(LoadPerformanceWSData(newValue!.ipAddress));
                });
              },
              items: _getDropdownItems(state.nodeList),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  List<DropdownMenuItem<Node>> _getDropdownItems(List<Node> nodes) {
    return nodes.map((node) {
      return DropdownMenuItem<Node>(
        value: node,
        child: Text(node.hostname),
      );
    }).toList();
  }

  Widget _buildListPerformance(PerformanceWSState state) {
    if (state is PerformanceWSLoading) {
      return Center(child: CircularProgressIndicator(color: HexColor("#3c1e08")));
    } else if (state is PerformanceWSError) {
      return Center(child: Text('Failed to load performance data'));
    } else if (state is PerformanceWSEmpty) {
      return Center(child: Text('No running container'));
    } else if (state is PerformanceWSLoaded) {
      if (state.performanceList.isEmpty) {
        return Center(child: Text("No Container Available"));
      }
      return ListView.builder(
        itemCount: state.performanceList.length,
        itemBuilder: (context, index) {
          final performance = state.performanceList[index];
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            performance.containerName,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateContainerScreen(containerId: performance.containerId),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'CPU Usage: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '${performance.cpuUsage}'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Memory Usage: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '${performance.memUsage}/${performance.memSize}'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Network: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '${performance.netInput}/${performance.netOutput}'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Block: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '${performance.blockInput}/${performance.blockOutput}'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'PIDs: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '${performance.pids}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    return SizedBox.shrink();
  }
}
