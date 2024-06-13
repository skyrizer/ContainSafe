import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/services/add/addService_bloc.dart';
import '../../bloc/services/add/addService_event.dart';
import '../../bloc/services/add/addService_state.dart';
import '../RoutePage.dart';
import '../RoutePage2.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {

  late AddServiceBloc _addServiceBloc;

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    _addServiceBloc = BlocProvider.of<AddServiceBloc>(context);
    _addServiceBloc.add(StartAddService());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addServiceBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 8.0,
              ),
              Text(
                'Add Service',
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: BlocListener<AddServiceBloc, AddServiceState>(
          listener: (context, state) {
            if (state is AddServiceSuccessState) {
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RoutePage()),
                );
              });
            }
          },
          child: BlocBuilder<AddServiceBloc, AddServiceState>(
            builder: (context, state) {
              if (state is AddServiceLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AddServiceFailState) {
                // Handle failure state
                return Center(
                  child: Text(state.message),
                );
              } else {
                // Handle initial state or any other state
                return _buildAddService();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddService() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Service name',
              labelStyle: TextStyle(color: Colors.brown),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Colors.brown), // Change the color here
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Dispatch an event to add node
                _addServiceBloc.add(AddServiceButtonPressed(
                  name: nameController.text,
                ));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.brown, // Change the background color here
              ),
              child: Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
