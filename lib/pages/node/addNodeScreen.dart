import 'package:containsafe/bloc/node/addNode/addNode_event.dart';
import 'package:containsafe/pages/node/viewNodesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/node/addNode/addNode_bloc.dart';
import '../../bloc/node/addNode/addNode_state.dart';
import '../../repository/webSocket_repo.dart';
import '../RoutePage.dart';
import '../RoutePage2.dart';

class AddNodeScreen extends StatefulWidget {
  const AddNodeScreen({Key? key}) : super(key: key);

  @override
  State<AddNodeScreen> createState() => _AddNodeScreenState();
}

class _AddNodeScreenState extends State<AddNodeScreen> {
  late AddNodeBloc _addNodeBloc;

  TextEditingController hostnameController = TextEditingController();
  TextEditingController ipAddrController = TextEditingController();
  bool _isConnecting = false;
  bool _connectionSuccessful = false;

  @override
  void initState() {
    _addNodeBloc = BlocProvider.of<AddNodeBloc>(context);
    super.initState();
  }

  Future<void> _testWebSocketConnection(String ipAddress) async {
    setState(() {
      _isConnecting = true;
    });

    // String url =
    //     "ws://$ipAddress:8080"; // Assume WebSocket server is running on port 8080
    WebSocketRepository webSocketRepository = WebSocketRepository("ws://$ipAddress:8080");

    bool success = await webSocketRepository.testConnection();

    setState(() {
      _isConnecting = false;
      _connectionSuccessful = success;
    });

    if (success) {
      _addNodeBloc.add(AddNodeButtonPressed(
                 hostname: hostnameController.text,
                 ipAddress: ipAddrController.text,
              ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ViewNodesScreen()),
      );
    } else {
      // Show connection failed message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection failed')),
      );
    }

    webSocketRepository.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addNodeBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'Add Node',
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: BlocListener<AddNodeBloc, AddNodeState>(
          listener: (context, state) {
            if (state is AddNodeSuccessState) {
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RoutePage()),
                );
              });
            }
          },
          child: BlocBuilder<AddNodeBloc, AddNodeState>(
            builder: (context, state) {
              if (state is AddNodeLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AddNodeFailState) {
                // Handle failure state
                return Center(
                  child: Text(state.message),
                );
              } else {
                // Handle initial state or any other state
                return _buildAddNode();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddNode() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: hostnameController,
            decoration: InputDecoration(
              labelText: 'Hostname',
              labelStyle: TextStyle(color: Colors.brown),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.brown), // Change the color here
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: ipAddrController,
            decoration: InputDecoration(labelText: 'IP Address'),
          ),
          SizedBox(height: 16.0),
          // Center(
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // Dispatch an event to add node
          //       _addNodeBloc.add(AddNodeButtonPressed(
          //         hostname: hostnameController.text,
          //         ipAddress: ipAddrController.text,
          //       ));
          //     },
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.brown, // Change the background color here
          //     ),
          //     child: Text('Save'),
          //   ),
          // ),
          Center(
            child: ElevatedButton(
              onPressed: _isConnecting
                  ? null
                  : () {
                _testWebSocketConnection(ipAddrController.text);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
              ),
              child: _isConnecting
                  ? CircularProgressIndicator()
                  : Text('Save'),
            ),
          ),
          SizedBox(height: 16.0),
          if (_connectionSuccessful)
            Center(
              child: Text(
                'Connection successful!',
                style: TextStyle(color: Colors.green),
              ),
            ),
          if (!_connectionSuccessful && !_isConnecting && ipAddrController.text.isNotEmpty)
            Center(
              child: Text(
                'Connection failed. Try again.',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
