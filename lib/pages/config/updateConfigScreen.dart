
import 'package:containsafe/model/config/config.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/config/update/editConfig_bloc.dart';
import '../../bloc/config/update/editConfig_event.dart';
import '../../bloc/config/update/editConfig_state.dart';
import '../SnackBarDesign.dart';

class UpdateConfigScreen extends StatefulWidget {

  final Config config; // Define config as a property of UpdateConfigScreen

  const UpdateConfigScreen({Key? key, required this.config}) : super(key: key);
  @override
  State<UpdateConfigScreen> createState() => UpdateConfigState();

}

class UpdateConfigState extends State<UpdateConfigScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController unitController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  late Config config;

  late EditConfigBloc updateConfigBloc;
  int containerEdited = 0;
  late int id;

  @override
  void initState() {
    // TODO: implement initState
    updateConfigBloc = BlocProvider.of<EditConfigBloc>(context);
    // Accessing the config passed to the screen
    config = widget.config;

    // Initialize the controllers with config values
    nameController.text = config.name!;
    unitController.text = config.unit!;
    id = config.id!;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Config', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      BlocListener<EditConfigBloc,EditConfigState>(
        listener: (context, state){
          if (state is EditConfigUpdated){
            Navigator.pop(context, true);
            final snackBar = SnackBarDesign.customSnackBar('Config has been updated');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child:BlocBuilder<EditConfigBloc,EditConfigState>(
          builder: (context, state){
            if (state is EditConfigUpdating){
              return Center(
                  child:
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Text("Updating...Please wait", style: TextStyle(fontSize: 16),),
                      SizedBox(height: 10),
                      CircularProgressIndicator(color:  HexColor("#3c1e08"),)
                    ],
                  )
              );
            }
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _nameField(),
                        _unitField(),
                        _updateButton(),
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  Widget _nameField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: nameController,
        decoration:  InputDecoration(
          // prefixIcon: Icon(Icons.house, color: HexColor("#3c1e08"),),
          labelText: 'Config name',
          labelStyle: TextStyle(color: HexColor("#3c1e08")),
          focusColor: HexColor("#3c1e08"),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4")),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  HexColor("#3c1e08")),
          ),
        ),
      ),
    );
  }

  Widget _unitField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: unitController,
        decoration:  InputDecoration(
          // prefixIcon: Icon(Icons.house, color: HexColor("#3c1e08"),),
          labelText: 'Config unit',
          labelStyle: TextStyle(color: HexColor("#3c1e08")),
          focusColor: HexColor("#3c1e08"),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: HexColor("#a4a4a4")),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:  HexColor("#3c1e08")),
          ),
        ),
      ),
    );
  }




  Widget _updateButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: 300.0,
        height: 55.0,
        child: ElevatedButton(
          onPressed: () async {
            if(_formKey.currentState!.validate()){
              // success validation
              String name = nameController.text;
              String unit = unitController.text;

              Config configUpdate = Config.edit(
                  id: id,
                  name: name,
                  unit: unit,

              );

              updateConfigBloc.add(UpdateConfigButtonPressed(config: configUpdate));
            }
            else {
              final snackBar = SnackBarDesign.customSnackBar('Having problem in updating config');
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder( borderRadius: BorderRadius.circular(24.0),)
            ),
            backgroundColor: MaterialStateProperty.all<HexColor>(HexColor("#3c1e08")),

          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('UPDATE', style: TextStyle(fontSize: 16),),
          ),
        ),
      ),
    );
  }


}
