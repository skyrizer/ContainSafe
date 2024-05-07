import 'package:containsafe/bloc/httpResponse/httpResponse_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/httpResponse/httpResponse_bloc.dart';
import '../../bloc/httpResponse/httpResponse_state.dart';
import '../../bloc/node/getAll/getAllNode_state.dart';


class ViewHttpResponsesScreen extends StatefulWidget {
  const ViewHttpResponsesScreen({Key? key}) : super(key: key);

  @override
  State<ViewHttpResponsesScreen> createState() => _ViewHttpResponsesScreenState();
}

class _ViewHttpResponsesScreenState extends State<ViewHttpResponsesScreen> {

  final GetHttpResponsesBloc _httpResponsesBloc = GetHttpResponsesBloc();

  @override
  void initState() {
    super.initState();
    _httpResponsesBloc.add(GetHttpResponses()); // Dispatch the event here
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _httpResponsesBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 8.0,
              ),
              Text('Request Log', style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: _buildListHttpResponses(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // Navigate to the page where you can add a new node
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => Route()),
        //     );
        //   },
        //   backgroundColor: HexColor("#3c1e08"),
        //   child: Icon(Icons.add),
        // ),
      ),
    );
  }

  Widget _buildListHttpResponses() {
    return Container(
      color: HexColor("#ecd9c9"),
      child: BlocBuilder<GetHttpResponsesBloc, GetHttpResponsesState>(
        builder: (context, state) {
          if (state is GetHttpResponsesError) {
            return Center(
              child: Text(state.error ?? "Error loading data"),
            );
          } else if (state is GetAllNodeInitial ||
              state is GetHttpResponsesLoading) {
            return Center(
              child: CircularProgressIndicator(color: HexColor("#3c1e08")),
            );
          } else if (state is GetHttpResponsesLoaded) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(primary: HexColor("#3c1e08")),
              ),
              child: ListView.builder(
                itemCount: state.httpResponses.length,
                itemBuilder: (context, index) {
                  final httpResponses = state.httpResponses[index];
                  return Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          httpResponses.method,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          httpResponses.url,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          httpResponses.ipAddress,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          httpResponses.statusCode.toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
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
