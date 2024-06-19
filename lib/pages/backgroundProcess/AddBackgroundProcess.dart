
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/backgroundProcess/add/addBp_bloc.dart';
import '../../bloc/backgroundProcess/add/addBp_event.dart';
import '../../bloc/backgroundProcess/add/addBp_state.dart';

class AddBackgroundProcessScreen extends StatefulWidget {
  final int serviceId;

  const AddBackgroundProcessScreen({Key? key, required this.serviceId})
      : super(key: key);


  @override
  State<AddBackgroundProcessScreen> createState() => _AddBackgroundProcessScreenState();
}

class _AddBackgroundProcessScreenState extends State<AddBackgroundProcessScreen> {

  late AddBpBloc _addBpBloc;

  TextEditingController nameController = TextEditingController();


  @override
  void initState() {
    _addBpBloc = BlocProvider.of<AddBpBloc>(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addBpBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Background Process', style: Theme.of(context).textTheme.bodyText1),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<AddBpBloc, AddBpState>(
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(AddBpState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bpName(),
          SizedBox(height: 16),
          saveButton(),
        ],
      ),
    );
  }


  Widget bpName() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child:  Text('Name'),
        ),
        SizedBox(width: 10), // Adding some space between the label and the TextField
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), // Adjust the values according to your preference
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter name',
                labelStyle: TextStyle(color: Colors.brown),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown), // Change the color here
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget saveButton(){
    return Center(

      child: ElevatedButton(
        onPressed: () {
          // Dispatch an event to add node
          _addBpBloc.add(AddBpButtonPressed(
              serviceId: widget!.serviceId!,
              name: nameController.text.trim()
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
