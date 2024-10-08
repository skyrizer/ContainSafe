import 'package:containsafe/bloc/backgroundProcess/getByService/getBpService_bloc.dart';
import 'package:containsafe/bloc/backgroundProcess/getByService/getBpService_event.dart';
import 'package:containsafe/pages/backgroundProcess/AddBackgroundProcess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/backgroundProcess/delete/deleteBp_bloc.dart';
import '../../bloc/backgroundProcess/delete/deleteBp_event.dart';
import '../../bloc/backgroundProcess/getByService/getBpService_state.dart';

class ViewBackgroundProcessesScreen extends StatefulWidget {
  final int serviceId;

  const ViewBackgroundProcessesScreen({Key? key, required this.serviceId})
      : super(key: key);

  @override
  State<ViewBackgroundProcessesScreen> createState() => _ViewBackgroundProcessesState();
}

class _ViewBackgroundProcessesState extends State<ViewBackgroundProcessesScreen> {
  final GetBpByServiceBloc _bpByServiceListBloc = GetBpByServiceBloc();
  late DeleteBpBloc _deleteBpBloc;

  @override
  void initState() {
    super.initState();
    _bpByServiceListBloc.add(
        GetBpByServiceList(serviceId: widget.serviceId)); // Dispatch the event here
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bpByServiceListBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text('Background Processes', style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: _buildListBp(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBackgroundProcessScreen(serviceId: widget.serviceId)),
            );

          },
          backgroundColor: HexColor("#3c1e08"),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildListBp() {
    return Container(
      color: HexColor("#ecd9c9"),
      child: BlocBuilder<GetBpByServiceBloc, GetBpByServiceState>(
        builder: (context, state) {
          if (state is GetBpByServiceError) {
            return Center(
              child: Text(state.error ?? "Error loading data"),
            );
          } else if (state is GetBpByServiceInitial ||
              state is GetBpByServiceLoading) {
            return Center(
              child: CircularProgressIndicator(color: HexColor("#3c1e08")),
            );
          } else if (state is GetBpByServiceLoaded) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(primary: HexColor("#3c1e08")),
              ),
              child: ListView.builder(
                itemCount: state.bpServiceList.length,
                itemBuilder: (context, index) {
                  final bps = state.bpServiceList[index];
                  return Container(
                    margin:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                              bps.name!,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          color: Colors.black,
                          onPressed: () {

                            _deleteBpBloc.add(DeleteBpButtonPressed(
                                serviceId: widget.serviceId!,
                                bpId: bps.id!,
                            ));

                            setState(() {
                              Navigator.pop(context);
                            });

                          },
                          icon: Icon(Icons.delete, color: Colors.brown),
                        ),
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
