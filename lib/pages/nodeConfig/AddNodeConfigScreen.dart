import 'package:containsafe/bloc/config/get/getConfig_bloc.dart';
import 'package:containsafe/bloc/config/get/getConfig_event.dart';
import 'package:containsafe/bloc/node/getAll/getAllNode_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/config/get/getConfig_state.dart';
import '../../bloc/node/getAll/getAllNode_bloc.dart';
import '../../bloc/node/getAll/getAllNode_state.dart';
import '../../bloc/nodeConfig/add/addNodeConfig_bloc.dart';
import '../../bloc/nodeConfig/add/addNodeConfig_state.dart';
import '../../model/config/config.dart';
import '../../model/node/node.dart';

class AddNodeConfigScreen extends StatefulWidget {
  const AddNodeConfigScreen({Key? key}) : super(key: key);

  @override
  State<AddNodeConfigScreen> createState() => _AddNodeConfigScreenState();
}

class _AddNodeConfigScreenState extends State<AddNodeConfigScreen> {

  final GetAllConfigBloc _getAllConfigBloc  = GetAllConfigBloc();
  final GetAllNodeBloc _getAllNodeBloc  = GetAllNodeBloc();
  late AddNodeConfigBloc _addNodeConfigBloc;
  Node? _selectedNode; // Selected node
  Config? _selectedConfig;


  TextEditingController valueController = TextEditingController();
  String selectedConfigId = '';
  String selectedNodeId = '';

  @override
  void initState() {
    _addNodeConfigBloc = BlocProvider.of<AddNodeConfigBloc>(context);
    _getAllConfigBloc .add(GetAllConfigList());
    _getAllNodeBloc .add(GetAllNodeList());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addNodeConfigBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ContainSafe', style: Theme.of(context).textTheme.bodyText1),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<AddNodeConfigBloc, AddNodeConfigState>(
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(AddNodeConfigState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNodeDropdown(), // Dropdown to select nodes
          SizedBox(height: 16),
          _buildConfigDropdown(),
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: DropdownButton<Node>(
                hint: Text('Select Node'),
                value: _selectedNode,
                onChanged: (newValue) {
                  setState(() {
                    _selectedNode = newValue; // Update selected node
                    _getAllNodeBloc.add(GetAllNodeList()); // Pass the id of the selected node
                  });
                },
                items: _getNodeDropdownItems(state.nodeList),
                // Display the hostname for each item
                // value will be the Node object itself
              ),
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

  Widget _buildConfigDropdown() {
    return BlocProvider<GetAllConfigBloc>(
      create: (context) => _getAllConfigBloc, // Provide the instance of GetAllNodeBloc
      child: BlocBuilder<GetAllConfigBloc, GetAllConfigState>(
        builder: (context, state) {
          if (state is GetAllConfigLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: DropdownButton<Config>(
                hint: Text('Select Configuration'),
                value: _selectedConfig,
                onChanged: (newValue) {
                  setState(() {
                    _selectedConfig = newValue; // Update selected node
                    _getAllConfigBloc.add(GetAllConfigList()); // Pass the id of the selected node
                  });
                },
                items: _getConfigDropdownItems(state.configList),
                // Display the hostname for each item
                // value will be the Node object itself
              ),
            );
          } else {
            // Handle loading or error state
            return SizedBox.shrink(); // Or display an error message
          }
        },
      ),
    );
  }

  List<DropdownMenuItem<Config>> _getConfigDropdownItems(List<Config> config) {
    return config.map((config) {
      return DropdownMenuItem<Config>(
        value: config,
        child: Text(config.name),
      );
    }).toList();
  }



}
