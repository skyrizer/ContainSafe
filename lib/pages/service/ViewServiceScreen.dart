
import 'package:containsafe/pages/backgroundProcess/ViewBackgroundProcess.dart';
import 'package:containsafe/pages/role/updateRoleScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/role/get/getRole_bloc.dart';
import '../../bloc/role/get/getRole_event.dart';
import '../../bloc/role/get/getRole_state.dart';
import '../../bloc/services/get/getServices_bloc.dart';
import '../../bloc/services/get/getServices_event.dart';
import '../../bloc/services/get/getServices_state.dart';
import 'AddServiceScreen.dart';

class ViewServicesScreen extends StatefulWidget {
  const ViewServicesScreen({Key? key}) : super(key: key);

  @override
  State<ViewServicesScreen> createState() => _ViewServicesScreenState();
}

class _ViewServicesScreenState extends State<ViewServicesScreen> {

  final GetAllServiceBloc _serviceListBloc = GetAllServiceBloc();
  // late DeleteNodeBloc _deleteNodeBloc;

  @override
  void initState() {
    super.initState();
    _serviceListBloc.add(GetAllServiceList()); // Dispatch the event here
    // _deleteNodeBloc = BlocProvider.of<DeleteNodeBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _serviceListBloc.add(GetAllServiceList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _serviceListBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 8.0,
              ),
              Text('Services', style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: _buildListRole(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the page where you can add a new node
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddServiceScreen()),
            );
          },
          backgroundColor: HexColor("#3c1e08"),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildListRole() {
    return Container(
      color: HexColor("#ecd9c9"),
      child: BlocBuilder<GetAllServiceBloc, GetAllServiceState>(
        builder: (context, state) {
          if (state is GetAllServiceError) {
            return Center(
              child: Text(state.error ?? "Error loading data"),
            );
          } else if (state is GetAllServiceInitial || state is GetAllServiceLoading) {
            return Center(
              child: CircularProgressIndicator(color: HexColor("#3c1e08")),
            );
          } else if (state is GetAllServiceLoaded) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(primary: HexColor("#3c1e08")),
              ),
              child: ListView.builder(
                itemCount: state.serviceList.length,
                itemBuilder: (context, index) {
                  final services = state.serviceList[index];
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              services.name!,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        PopupMenuButton<int>(
                          onSelected: (value) {
                            if (value == 1) {
                              // Handle other action here
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ViewBackgroundProcessesScreen(serviceId: services.id)),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.settings, color: Colors.brown),
                                  SizedBox(width: 8),
                                  Text('Background Process'),
                                ],
                              ),
                            ),
                          ],
                          icon: Icon(Icons.more_vert, color: Colors.black),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return SizedBox.shrink(); // Return an empty widget if none of the conditions match
        },
      ),
    );
  }


}
