

import 'package:containsafe/model/service/service_status.dart';
import 'package:containsafe/model/node/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../bloc/services/get/getServices_bloc.dart';
import '../../bloc/services/get/getServices_event.dart';
import '../../bloc/services/get/getServices_state.dart';


class ViewServiceScreen extends StatefulWidget {
  final Node node;
  const ViewServiceScreen({super.key, required this.node});

  @override
  State<ViewServiceScreen> createState() => _ViewServiceScreenState();
}

class _ViewServiceScreenState extends State<ViewServiceScreen> {

  late GetServicesBloc _getServicesBloc;


  Node? _selectedNode;
  List<ServiceStatus> _nodeConfigList = [];

  @override
  void initState() {
    super.initState();
    _getServicesBloc = GetServicesBloc()..add(LoadGetServicesData(widget.node.ipAddress));

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
        title: Text('Service Status'),
      ),
      body: BlocBuilder<GetServicesBloc, GetServicesState>(
        builder: (context, state) {
          if (state is GetServicesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GetServicesLoaded) {
            return _buildServiceList(state.statusList);
          } else if (state is GetServicesError) {
            return Center(child: Text(state.error));
          } else {
            return Center(child: Text('Unknown state'));
          }
        },
      ),
    )
    );
  }

  Widget _buildServiceList(List<ServiceStatus> serviceStatusList) {
    return ListView.builder(
      itemCount: serviceStatusList.length,
      itemBuilder: (context, index) {
        final serviceStatus = serviceStatusList[index];
        return ListTile(
          title: Text('Service ${index + 1}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildServiceStatus('Apache', serviceStatus.apache),
              _buildServiceStatus('MySQL', serviceStatus.mysql),
              _buildServiceStatus('Tomcat', serviceStatus.tomcat),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceStatus(String serviceName, bool isRunning) {
    return Row(
      children: [
        Text(serviceName),
        SizedBox(width: 8),
        Text(
          isRunning ? 'Running' : 'Stopped',
          style: TextStyle(
            color: isRunning ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


}
