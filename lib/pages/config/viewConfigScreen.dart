
import 'package:containsafe/pages/config/updateConfigScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/config/get/getConfig_bloc.dart';
import '../../bloc/config/get/getConfig_event.dart';
import '../../bloc/config/get/getConfig_state.dart';
import 'addConfigScreen.dart';


class ViewConfigsScreen extends StatefulWidget {
  const ViewConfigsScreen({Key? key}) : super(key: key);

  @override
  State<ViewConfigsScreen> createState() => _ViewConfigsScreenState();
}

class _ViewConfigsScreenState extends State<ViewConfigsScreen> {

  final GetAllConfigBloc _configListBloc = GetAllConfigBloc();
  // late DeleteNodeBloc _deleteNodeBloc;

  @override
  void initState() {
    super.initState();
    _configListBloc.add(GetAllConfigList()); // Dispatch the event here
    // _deleteNodeBloc = BlocProvider.of<DeleteNodeBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _configListBloc.add(GetAllConfigList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _configListBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 8.0,
              ),
              Text('Configs', style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: _buildListNode(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the page where you can add a new node
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddConfigScreen()),
            );
          },
          backgroundColor: HexColor("#3c1e08"),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildListNode() {
    return Container(
      color: HexColor("#ecd9c9"),
      child: BlocBuilder<GetAllConfigBloc, GetAllConfigState>(
        builder: (context, state) {
          if (state is GetAllConfigError) {
            return Center(
              child: Text(state.error ?? "Error loading data"),
            );
          } else if (state is GetAllConfigInitial || state is GetAllConfigLoading) {
            return Center(
              child: CircularProgressIndicator(color: HexColor("#3c1e08")),
            );
          } else if (state is GetAllConfigLoaded) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(primary: HexColor("#3c1e08")),
              ),
              child: ListView.builder(
                itemCount: state.configList.length,
                itemBuilder: (context, index) {
                  final configs = state.configList[index];
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
                              configs!.name ?? '', // Use the null-aware operator (??) to provide a default empty string if configs!.name is null
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              configs!.unit ?? '',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        PopupMenuButton<int>(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.brown),
                                ],
                              ),
                            ),
                          ],
                          icon: Icon(Icons.more_vert, color: Colors.black),
                          onSelected: (value) {
                            // Handle edit functionality here
                            if (value == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UpdateConfigScreen(config: configs)),
                              );
                            }
                          },
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
