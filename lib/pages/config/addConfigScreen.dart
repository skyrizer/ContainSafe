import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/config/add/addConfig_bloc.dart';
import '../../bloc/config/add/addConfig_event.dart';
import '../../bloc/config/add/addConfig_state.dart';
import '../RoutePage.dart';
import '../RoutePage2.dart';

class AddConfigScreen extends StatefulWidget {
  const AddConfigScreen({Key? key}) : super(key: key);

  @override
  State<AddConfigScreen> createState() => _AddConfigScreenState();
}

class _AddConfigScreenState extends State<AddConfigScreen> {
  late AddConfigBloc _addConfigBloc;

  TextEditingController nameController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  @override
  void initState() {
    _addConfigBloc = BlocProvider.of<AddConfigBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addConfigBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'Add Config',
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: BlocListener<AddConfigBloc, AddConfigState>(
          listener: (context, state) {
            if (state is AddConfigSuccessState) {
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RoutePage()),
                );
              });
            }
          },
          child: BlocBuilder<AddConfigBloc, AddConfigState>(
            builder: (context, state) {
              if (state is AddConfigLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AddConfigFailState) {
                // Handle failure state
                return Center(
                  child: Text(state.message),
                );
              } else {
                // Handle initial state or any other state
                return _buildAddConfig();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddConfig() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Config name',
              labelStyle: TextStyle(color: HexColor("#3c1e08")),
              focusColor: HexColor("#3c1e08"),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: HexColor("#a4a4a4")),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: HexColor("#3c1e08")),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: unitController,
            decoration: InputDecoration(
              labelText: 'Config unit',
              labelStyle: TextStyle(color: HexColor("#3c1e08")),
              focusColor: HexColor("#3c1e08"),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: HexColor("#a4a4a4")),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: HexColor("#3c1e08")),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Dispatch an event to add node
                _addConfigBloc.add(AddConfigButtonPressed(
                  name: nameController.text,
                  unit: unitController.text,
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
