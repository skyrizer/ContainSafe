import 'package:containsafe/bloc/backgroundProcess/add/addBp_bloc.dart';
import 'package:containsafe/model/service/service_status.dart';
import 'package:containsafe/model/node/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/services/getByNode/getNodeServices_bloc.dart';
import '../../bloc/services/getByNode/getNodeServices_event.dart';
import '../../bloc/services/getByNode/getNodeServices_state.dart';
import '../../repository/webSocket_repo.dart';
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
  int? roleId;

  @override
  void initState() {
    super.initState();
    _getRoleId();
    _getServicesBloc = GetNodeServicesBloc()..add(LoadGetServicesData(widget.node.ipAddress));
    _addBpBloc = BlocProvider.of<AddBpBloc>(context);

  }

  @override
  void dispose() {
    _getServicesBloc.close();
    super.dispose();
  }

  Future<void> _getRoleId() async {
    await Future.delayed(Duration(seconds: 2)); // Add a 2-second delay
    var pref = await SharedPreferences.getInstance(); // Await the future
    setState(() {
      roleId = pref.getInt("roleId"); // Handle potential null value
    });
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
        floatingActionButton: roleId == 3 // Check if roleId is 3
            ? null // If roleId is 3, do not display FloatingActionButton
            : FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNodeServiceScreen(node: widget.node,)),
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
          Row(
            children: [
              Text(
                isRunning ? 'Running' : 'Not Running',
                style: TextStyle(
                  color: isRunning ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isRunning) ...[ // Use spread operator to include both SizedBox and ElevatedButton
                SizedBox(width: 10), // Space between status and button
                ElevatedButton(
                  onPressed: () {
                    // Add your logic to start the service here
                    // You may dispatch an event or call a method from your BLoC or provider
                    print('Starting service: $serviceName');
                    _sendServiceName(serviceName);
                  },
                  child: Text('Start'),
                  style: ElevatedButton.styleFrom(
                    primary: HexColor("#3c1e08"), // Background color
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _sendServiceName(String service) async {
    final webSocketRepository =
    WebSocketRepository('ws://${widget.node.ipAddress}:8765');
    webSocketRepository.sendServiceName(service);
  }

}
