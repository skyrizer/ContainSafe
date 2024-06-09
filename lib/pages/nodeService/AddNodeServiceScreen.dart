
import 'package:containsafe/bloc/node/getAll/getAllNode_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/node/getAll/getAllNode_bloc.dart';
import '../../bloc/node/getAll/getAllNode_state.dart';
import '../../bloc/nodeService/add/addNodeService_bloc.dart';
import '../../bloc/nodeService/add/addNodeService_event.dart';
import '../../bloc/nodeService/add/addNodeService_state.dart';
import '../../bloc/services/get/getServices_bloc.dart';
import '../../bloc/services/get/getServices_event.dart';
import '../../bloc/services/get/getServices_state.dart';
import '../../model/node/node.dart';
import '../../model/service/service_model..dart';
import '../../repository/nodeService_repo.dart';

class AddNodeServiceScreen extends StatefulWidget {

  final Node node;
  const AddNodeServiceScreen({super.key, required this.node});


  @override
  State<AddNodeServiceScreen> createState() => _AddNodeServiceScreenState();
}

class _AddNodeServiceScreenState extends State<AddNodeServiceScreen> {

  NodeServiceRepository repo = NodeServiceRepository();
  final GetAllServiceBloc _getAllServiceBloc  = GetAllServiceBloc();
  final GetAllNodeBloc _getAllNodeBloc  = GetAllNodeBloc();

  late AddNodeServiceBloc _addNodeServiceBloc;
  Node? _selectedNode; // Selected node
  ServiceModel? _selectedService;



  @override
  void initState() {

    _addNodeServiceBloc = BlocProvider.of<AddNodeServiceBloc>(context);

    try {
      // Try adding an event to the Bloc
      _addNodeServiceBloc.add(StartNodeServiceRegister());
    } catch (error) {
      // If adding the event fails due to the Bloc being closed, recreate the Bloc
      _addNodeServiceBloc = AddNodeServiceBloc(AddNodeServiceInitState(), repo);
      _addNodeServiceBloc.add(StartNodeServiceRegister());
    }

    _getAllNodeBloc.add(GetAllNodeList());
    _getAllServiceBloc.add(GetAllServiceList());

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addNodeServiceBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Node Service', style: Theme.of(context).textTheme.bodyText1),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<AddNodeServiceBloc, AddNodeServiceState>(
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(AddNodeServiceState state) {
    if (state is AddNodeServiceLoadingState) {
      return Center(
        child: CircularProgressIndicator(), // Show a loading indicator
      );
    } else if (state is AddNodeServiceFailState) {
      return Center(
        child: Text("Failed to add node service: ${state.message}"), // Show an error message
      );
    } else if (state is AddNodeServiceSuccessState) {
      Navigator.of(context).pop();
      return Container();
    } else {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildNodeDropdown(), // Dropdown to select nodes
            // SizedBox(height: 16),
            _buildServiceDropdown(),
            SizedBox(height: 16),
            saveButton(),
          ],
        ),
      );
    }
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

  Widget _buildServiceDropdown() {
    return BlocProvider<GetAllServiceBloc>(
      create: (context) => _getAllServiceBloc, // Provide the instance of GetAllNodeBloc
      child: BlocBuilder<GetAllServiceBloc, GetAllServiceState>(
        builder: (context, state) {
          if (state is GetAllServiceLoaded) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child:  Text('Service'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: DropdownButton<ServiceModel>(
                    hint: Text('Select Service'),
                    value: _selectedService,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedService = newValue; // Update selected node
                      });
                    },
                    items: _getUserDropdownItems(state.serviceList),
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

  List<DropdownMenuItem<ServiceModel>> _getUserDropdownItems(List<ServiceModel> service) {
    return service.map((service) {
      return DropdownMenuItem<ServiceModel>(
        value: service,
        child: Text(service.name!),
      );
    }).toList();
  }



  Widget saveButton(){
    return Center(

      child: ElevatedButton(
        onPressed: () {
          // Dispatch an event to add node
          _addNodeServiceBloc.add(AddNodeServiceButtonPressed(
              nodeId: widget.node.id!,
              serviceId: _selectedService!.id!,
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
