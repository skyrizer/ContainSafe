
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/config/update/editConfig_bloc.dart';
import '../../bloc/config/update/editConfig_state.dart';
import '../../bloc/permission/edit/editPermission_bloc.dart';
import '../../bloc/permission/edit/editPermission_event.dart';
import '../../bloc/permission/edit/editPermission_state.dart';
import '../../bloc/role/edit/editRole_bloc.dart';
import '../../bloc/role/edit/editRole_event.dart';
import '../../model/permission/permission.dart';
import '../../model/role/role.dart';
import '../SnackBarDesign.dart';

class UpdatePermissionScreen extends StatefulWidget {

  final Permission permission; // Define config as a property of UpdateConfigScreen

  const UpdatePermissionScreen({Key? key, required this.permission}) : super(key: key);
  @override
  State<UpdatePermissionScreen> createState() => UpdatePermissionState();

}

class UpdatePermissionState extends State<UpdatePermissionScreen> {

  TextEditingController nameController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  late Permission permission;

  late EditPermissionBloc updatePermissionBloc;
  int containerEdited = 0;
  late int id;

  @override
  void initState() {
    // TODO: implement initState
    updatePermissionBloc = BlocProvider.of<EditPermissionBloc>(context);
    // Accessing the config passed to the screen
    permission = widget.permission;

    // Initialize the controllers with config values
    nameController.text = permission.name!;
    id = permission.id!;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Permission', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      BlocListener<EditPermissionBloc,EditPermissionState>(
        listener: (context, state){
          if (state is EditPermissionUpdated){
            Navigator.pop(context, true);
            final snackBar = SnackBarDesign.customSnackBar('Permission has been updated');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child:BlocBuilder<EditPermissionBloc,EditPermissionState>(
            builder: (context, state){
              if (state is EditPermissionUpdating){
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
          labelText: 'Permission name',
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

              Permission permissionUpdate = Permission.edit(
                id: id,
                name: name,
              );

              updatePermissionBloc.add(UpdatePermissionButtonPressed(permission: permissionUpdate));
            }
            else {
              final snackBar = SnackBarDesign.customSnackBar('Having problem in updating permission');
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
