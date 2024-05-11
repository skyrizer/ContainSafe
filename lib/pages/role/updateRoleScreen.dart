
import 'package:containsafe/model/config/config.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/config/update/editConfig_bloc.dart';
import '../../bloc/config/update/editConfig_event.dart';
import '../../bloc/config/update/editConfig_state.dart';
import '../../bloc/role/edit/editRole_bloc.dart';
import '../../bloc/role/edit/editRole_event.dart';
import '../../model/role/role.dart';
import '../SnackBarDesign.dart';

class UpdateRoleScreen extends StatefulWidget {

  final Role role; // Define config as a property of UpdateConfigScreen

  const UpdateRoleScreen({Key? key, required this.role}) : super(key: key);
  @override
  State<UpdateRoleScreen> createState() => UpdateRoleState();

}

class UpdateRoleState extends State<UpdateRoleScreen> {

  TextEditingController roleController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  late Role role;

  late EditRoleBloc updateRoleBloc;
  int containerEdited = 0;
  late int id;

  @override
  void initState() {
    // TODO: implement initState
    updateRoleBloc = BlocProvider.of<EditRoleBloc>(context);
    // Accessing the config passed to the screen
    role = widget.role;

    // Initialize the controllers with config values
    roleController.text = role.role!;
    id = role.id!;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Role', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      BlocListener<EditConfigBloc,EditConfigState>(
        listener: (context, state){
          if (state is EditConfigUpdated){
            Navigator.pop(context, true);
            final snackBar = SnackBarDesign.customSnackBar('Container has been updated');
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
                        _roleField(),
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

  Widget _roleField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: roleController,
        decoration:  InputDecoration(
          // prefixIcon: Icon(Icons.house, color: HexColor("#3c1e08"),),
          labelText: 'Role name',
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
              String role = roleController.text;

              Role roleUpdate = Role.edit(
                id: id,
                role: role,
              );

              updateRoleBloc.add(UpdateRoleButtonPressed(role: roleUpdate));
            }
            else {
              final snackBar = SnackBarDesign.customSnackBar('Having problem in updating role');
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
