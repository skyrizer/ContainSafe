import 'package:containsafe/bloc/node/addNode/addNode_event.dart';
import 'package:containsafe/pages/node/viewNodesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/node/addNode/addNode_bloc.dart';
import '../../bloc/node/addNode/addNode_state.dart';
import '../RoutePage.dart';

class AddNodeScreen extends StatefulWidget {
  const AddNodeScreen({Key? key}) : super(key: key);

  @override
  State<AddNodeScreen> createState() => _AddNodeScreenState();
}

class _AddNodeScreenState extends State<AddNodeScreen> {

  late AddNodeBloc _addNodeBloc;

  TextEditingController hostnameController = TextEditingController();
  TextEditingController ipAddrController = TextEditingController();

  @override
  void initState() {
    _addNodeBloc = BlocProvider.of<AddNodeBloc>(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addNodeBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 8.0,
              ),
              Text(
                'Add Node',
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
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
            decoration: InputDecoration(labelText: 'Hostname'),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: ipAddrController,
            decoration: InputDecoration(labelText: 'IP Address'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Dispatch an event to add node
              _addNodeBloc.add(AddNodeButtonPressed(
                hostname: hostnameController.text,
                ipAddress: ipAddrController.text,
              ));
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.brown, // Change the background color here
            ),
            child: Text('Add Node'),
          ),
        ],
      ),
    );
  }
}
