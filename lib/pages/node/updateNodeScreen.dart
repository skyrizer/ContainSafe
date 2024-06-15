
import 'package:containsafe/model/config/config.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/config/update/editConfig_bloc.dart';
import '../../bloc/config/update/editConfig_event.dart';
import '../../bloc/config/update/editConfig_state.dart';
import '../../bloc/node/update/updateNode_bloc.dart';
import '../../bloc/node/update/updateNode_event.dart';
import '../../bloc/node/update/updateNode_state.dart';
import '../../model/node/node.dart';
import '../SnackBarDesign.dart';

class UpdateNodeScreen extends StatefulWidget {

  final Node node; // Define config as a property of UpdateConfigScreen

  const UpdateNodeScreen({Key? key, required this.node}) : super(key: key);
  @override
  State<UpdateNodeScreen> createState() => UpdateNodeState();

}

class UpdateNodeState extends State<UpdateNodeScreen> {

  TextEditingController hostnameController = TextEditingController();
  TextEditingController ipAddressController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  late Node node;

  late EditNodeBloc updateNodeBloc;
  int nodeEdited = 0;
  late int id;

  @override
  void initState() {
    // TODO: implement initState
    updateNodeBloc = BlocProvider.of<EditNodeBloc>(context);
    // Accessing the config passed to the screen
    node = widget.node;

    // Initialize the controllers with config values
    hostnameController.text = node.hostname!;
    ipAddressController.text = node.ipAddress!;
    id = node.id!;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Node', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      BlocListener<EditNodeBloc,EditNodeState>(
        listener: (context, state){
          if (state is EditNodeUpdated){
            Navigator.pop(context, true);
            final snackBar = SnackBarDesign.customSnackBar('Config has been updated');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child:BlocBuilder<EditNodeBloc,EditNodeState>(
            builder: (context, state){
              if (state is EditNodeUpdating){
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
                        _hostnameField(),
                        _ipAddressField(),
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

  Widget _hostnameField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: hostnameController,
        decoration:  InputDecoration(
          // prefixIcon: Icon(Icons.house, color: HexColor("#3c1e08"),),
          labelText: 'Hostname',
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

  Widget _ipAddressField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: ipAddressController,
        decoration:  InputDecoration(
          // prefixIcon: Icon(Icons.house, color: HexColor("#3c1e08"),),
          labelText: 'Ip Address',
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
              String hostname = hostnameController.text.trim();
              String ipAddress = ipAddressController.text.trim();

              Node nodeUpdate = Node.edit(
                id: id,
                hostname: hostname,
                ipAddress: ipAddress,

              );

              updateNodeBloc.add(UpdateNodeButtonPressed(node: nodeUpdate));
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
