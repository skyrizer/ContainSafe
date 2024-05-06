import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:containsafe/bloc/container/get/getContainer_bloc.dart';
import 'package:containsafe/bloc/container/get/getContainer_event.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:containsafe/model/container/container.dart';
import '../../bloc/container/get/getContainer_state.dart';
import '../SnackBarDesign.dart';

class UpdateContainerScreen extends StatefulWidget {

  final List<Map<String, dynamic>> containerId; // Add containerId parameter

  const UpdateContainerScreen({Key? key, required this.containerId}) : super(key: key);

  @override
  State<UpdateContainerScreen> createState() => UpdateContainerState();

}

class UpdateContainerState extends State<UpdateContainerScreen> {

  TextEditingController diskLimitController = TextEditingController();
  TextEditingController memLimitController = TextEditingController();
  TextEditingController netLimitController = TextEditingController();
  TextEditingController cpuLimitController = TextEditingController();
  TextEditingController containNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late ContainerModel container;

  late GetContainerBloc updateContainerBloc;
  int containerEdited = 0;

  @override
  void initState() {
    // TODO: implement initState
    updateContainerBloc = BlocProvider.of<GetContainerBloc>(context);
    updateContainerBloc.add(StartLoadContainer(containerId: "${widget.containerId[0]['container_id']}"));

    // Listen to state changes in the bloc
    updateContainerBloc.stream.listen((state) {
      if (state is GetContainerLoadedState) {
        // Access container data from the state and update text controllers
        container = state.containerData;
        containNameController.text = container.name ?? '';
        cpuLimitController.text = container.cpuLimit?.toString() ?? '';
        memLimitController.text = container.memLimit?.toString() ?? '';
        diskLimitController.text = container.diskLimit?.toString() ?? '';
        netLimitController.text = container.netLimit?.toString() ?? '';
      }
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Container', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      BlocListener<GetContainerBloc,GetContainerState>(
        listener: (context, state){
          if (state is GetContainerUpdated){
            Navigator.pop(context, true);
            final snackBar = SnackBarDesign.customSnackBar('Container has been updated');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child:BlocBuilder<GetContainerBloc, GetContainerState>(
          builder: (context, state){
            if (state is GetContainerLoadingState){
              return Center(child: CircularProgressIndicator(color:  HexColor("#3c1e08"),));
            }
            else if (state is GetContainerUpdating){
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
            else if (state is GetContainerLoadedState){
              print(state.containerData.name);
              container = state.containerData;
              //   define the text controller
              if (containNameController.text == ""){
                containNameController.text = container.name!;
              }
              if (cpuLimitController.text == ""){
                cpuLimitController.text = container.cpuLimit!.toString();
              }
              if (memLimitController.text == "") {
                memLimitController.text = container.memLimit!.toString();
              }
              if (diskLimitController.text == ""){
                diskLimitController.text = container.diskLimit!.toString();
              }
              if (netLimitController.text == "") {
                netLimitController.text = container.netLimit!.toString();
              }
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _containerNameField(),
                        _diskLimitField(),
                        _memLimitField(),
                        _cpuLimitField(),
                        _netLimitField(),
                        _updateButton(),
                      ],
                    ),
                  ),
                ),
              );
            }
            else{
              return Container();
            }
          },
        ),
      ),
    );
  }


  Widget _containerNameField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        readOnly: true,
        // validator: (value) {
        //   if (value == null || value.isEmpty){
        //     return 'Please enter full name';
        //   }
        //   return null;
        // },
        controller: containNameController,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.account_box_rounded, color: HexColor("#3c1e08"),),
          labelText: 'Full name',
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

  Widget _diskLimitField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: diskLimitController,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.house, color: HexColor("#3c1e08"),),
          labelText: 'Disk Limit',
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

  Widget _memLimitField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: memLimitController,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.house, color: HexColor("#3c1e08"),),
          labelText: 'Memory Limit',
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

  Widget _netLimitField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: netLimitController,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.house, color: HexColor("#3c1e08"),),
          labelText: 'Network Limit',
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

  Widget _cpuLimitField(){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: cpuLimitController,
        decoration:  InputDecoration(
          prefixIcon: Icon(Icons.house, color: HexColor("#3c1e08"),),
          labelText: 'CPU Limit',
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
              String name = container.name!;
              int diskLimit = int.parse(diskLimitController.text);
              int netLimit = int.parse(netLimitController.text);
              int memLimit = int.parse(memLimitController.text);
              int cpuLimit = int.parse(cpuLimitController.text);


              ContainerModel containerUpdate = ContainerModel.edit(
                id: widget.containerId[0]['container_id'],
                diskLimit: diskLimit,
                netLimit: netLimit,
                memLimit: memLimit,
                cpuLimit: cpuLimit

              );

              updateContainerBloc.add(UpdateButtonPressed(container: containerUpdate));
            }
            else {
              final snackBar = SnackBarDesign.customSnackBar('Having problem in updating container');
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
