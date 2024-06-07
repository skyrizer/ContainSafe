import 'package:containsafe/bloc/backgroundProcess/add/addBp_bloc.dart';
import 'package:containsafe/model/service/service_status.dart';
import 'package:containsafe/model/node/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/services/getByNode/getNodeServices_bloc.dart';
import '../../bloc/services/getByNode/getNodeServices_event.dart';
import '../../bloc/services/getByNode/getNodeServices_state.dart';
import '../service/AddServiceScreen.dart';
import 'AddNodeServiceScreen.dart';

class ViewNodeServiceScreen extends StatefulWidget {
  final Node node;
  const ViewNodeServiceScreen({super.key, required this.node});

  @override
  State<ViewNodeServiceScreen> createState() => _ViewNodeServiceScreenState();
}

class _ViewNodeServiceScreenState extends State<ViewNodeServiceScreen> {
  late GetNodeServicesBloc _getServicesBloc;
  late AddBpBloc _addBpBloc;

  @override
  void initState() {
    super.initState();
    _getServicesBloc = GetNodeServicesBloc()..add(LoadGetServicesData(widget.node.ipAddress));
    _addBpBloc = BlocProvider.of<AddBpBloc>(context);
  }

  @override
  void dispose() {
    _getServicesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getServicesBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('Service Status', style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          elevation: 0.0,
        ),
        body: Container(
          color: HexColor("#ecd9c9"),
          child: BlocBuilder<GetNodeServicesBloc, GetNodeServicesState>(
            builder: (context, state) {
              if (state is GetServicesLoading) {
                return Center(child: CircularProgressIndicator(color: HexColor("#3c1e08")));
              } else if (state is GetServicesLoaded) {
                return _buildServiceList(state.statusList);
              } else if (state is GetServicesError) {
                return Center(child: Text(state.error));
              } else {
                return Center(child: Text('Unknown state'));
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your action here
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNodeServiceScreen(node: widget.node)),
            );

          },
          backgroundColor: HexColor("#3c1e08"),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildServiceList(List<ServiceStatus> serviceStatusList) {
    return ListView.builder(
      itemCount: serviceStatusList.length,
      itemBuilder: (context, index) {
        final serviceStatus = serviceStatusList[index];
        return _buildServiceContainer(serviceStatus.name, serviceStatus.value);
      },
    );
  }

  Widget _buildServiceContainer(String serviceName, bool isRunning) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            serviceName,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            isRunning ? 'Running' : 'Not Running',
            style: TextStyle(
              color: isRunning ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
