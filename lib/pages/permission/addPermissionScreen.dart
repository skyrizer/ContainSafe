import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/permission/add/addPermission_bloc.dart';
import '../../bloc/permission/add/addPermission_event.dart';
import '../../bloc/permission/add/addPermission_state.dart';
import '../../bloc/role/add/addRole_state.dart';
import '../RoutePage.dart';

class AddRoleScreen extends StatefulWidget {
  const AddRoleScreen({Key? key}) : super(key: key);

  @override
  State<AddRoleScreen> createState() => _AddRoleScreenState();
}

class _AddRoleScreenState extends State<AddRoleScreen> {
  late AddPermissionBloc _addPermissionBloc;

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    _addPermissionBloc = BlocProvider.of<AddPermissionBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addPermissionBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 8.0,
              ),
              Text(
                'Add Permission',
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: BlocListener<AddPermissionBloc, AddPermissionState>(
          listener: (context, state) {
            if (state is AddRoleSuccessState) {
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RoutePage()),
                );
              });
            }
          },
          child: BlocBuilder<AddPermissionBloc, AddPermissionState>(
            builder: (context, state) {
              if (state is AddPermissionLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AddPermissionFailState) {
                // Handle failure state
                return Center(
                  child: Text(state.message),
                );
              } else {
                // Handle initial state or any other state
                return _buildAddPermission();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddPermission() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Permission name',
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
                _addPermissionBloc.add(AddPermissionButtonPressed(
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
