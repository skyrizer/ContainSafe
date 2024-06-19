import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/role/add/addRole_bloc.dart';
import '../../bloc/role/add/addRole_event.dart';
import '../../bloc/role/add/addRole_state.dart';
import '../RoutePage.dart';

class AddRoleScreen extends StatefulWidget {
  const AddRoleScreen({Key? key}) : super(key: key);

  @override
  State<AddRoleScreen> createState() => _AddRoleScreenState();
}

class _AddRoleScreenState extends State<AddRoleScreen> {
  late AddRoleBloc _addRoleBloc;

  TextEditingController roleController = TextEditingController();

  @override
  void initState() {
    _addRoleBloc = BlocProvider.of<AddRoleBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addRoleBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 8.0,
              ),
              Text(
                'Add Role',
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: BlocListener<AddRoleBloc, AddRoleState>(
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
          child: BlocBuilder<AddRoleBloc, AddRoleState>(
            builder: (context, state) {
              if (state is AddRoleLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AddRoleFailState) {
                // Handle failure state
                return Center(
                  child: Text(state.message),
                );
              } else {
                // Handle initial state or any other state
                return _buildAddRole();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddRole() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: roleController,
            decoration: InputDecoration(
              labelText: 'Role name',
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
                _addRoleBloc.add(AddRoleButtonPressed(
                  role: roleController.text,
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
