import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:containsafe/model/httpResponse/httpResponse.dart';

import '../../bloc/httpResponse/searchByDate/searchByDate_bloc.dart';
import '../../bloc/httpResponse/searchByDate/searchByDate_event.dart';
import '../../bloc/httpResponse/searchByDate/searchByDate_state.dart';

class SearchByDateView extends StatefulWidget {
  const SearchByDateView({super.key});

  @override
  State<SearchByDateView> createState() => _SearchByDateViewState();
}

class _SearchByDateViewState extends State<SearchByDateView> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  List<HttpResponse> httpResponselist = [];
  late SearchByDateBloc searchByDateBloc;

  @override
  void initState() {
    super.initState();
    searchByDateBloc = BlocProvider.of<SearchByDateBloc>(context);
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#ecd9c9"),
        bottomOpacity: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            color: HexColor("#D0D4CA"),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                startDateField(context),
                SizedBox(width: 16.0,),
                endDateField(context),
                IconButton(onPressed: () {
                  if (startDateController.text.isNotEmpty && endDateController.text.isNotEmpty) {
                    searchByDateBloc.add(SearchByDatePressed(
                      startDate: startDateController.text.trim(),
                      endDate: endDateController.text.trim(),
                    ));
                  }
                }, icon: const Icon(Icons.search)),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchByDateBloc, SearchByDateState>(
        builder: (context, state) {
          if (state is SearchByDateLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: HexColor("#3c1e08"),
              ),
            );
          } else if (state is SearchByDateLoadedState) {
            httpResponselist = state.searchByDateList;
            return _buildInteractiveList();
          } else if (state is SearchByDateErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return Center(
            child: Text(
              "No data available",
              style: const TextStyle(color: Colors.black),
            ),
          );
        },
      ),
    );
  }

  Widget startDateField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: 120,
      child: TextFormField(
        controller: startDateController,
        decoration: InputDecoration(
          hintText: "Start Date",
          focusColor: HexColor("#3c1e08"),
        ),
        readOnly: true,
        onTap: () => _selectDate(context, startDateController),
      ),
    );
  }

  Widget endDateField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: 120,
      child: TextFormField(
        controller: endDateController,
        decoration: InputDecoration(
          hintText: "End Date",
          focusColor: HexColor("#3c1e08"),
        ),
        readOnly: true,
        onTap: () => _selectDate(context, endDateController),
      ),
    );
  }

  Widget _buildInteractiveList() {
    Map<int, int> statusCodeCounts = {};
    for (var response in httpResponselist) {
      statusCodeCounts[response.statusCode] = (statusCodeCounts[response.statusCode] ?? 0) + 1;
    }

    // Group status codes by category
    Map<String, List<MapEntry<int, int>>> groupedStatusCodes = {
      "2xx Success": statusCodeCounts.entries.where((entry) => entry.key >= 200 && entry.key < 300).toList(),
      "3xx Redirection": statusCodeCounts.entries.where((entry) => entry.key >= 300 && entry.key < 400).toList(),
      "4xx Client Errors": statusCodeCounts.entries.where((entry) => entry.key >= 400 && entry.key < 500).toList(),
      "5xx Server Errors": statusCodeCounts.entries.where((entry) => entry.key >= 500 && entry.key < 600).toList(),
    };

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: groupedStatusCodes.entries.map((group) {
        return ExpansionTile(
          title: Text(
            group.key,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _getColorForGroup(group.key)),
          ),
          children: group.value.map((entry) {
            return ListTile(
              title: Text('Status Code: ${entry.key}'),
              trailing: CircleAvatar(
                backgroundColor: _getColorForStatusCode(entry.key),
                child: Text(
                  entry.value.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: entry.value.toString().length > 3 ? 10 : 14, // Adjust font size based on the number of digits
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Color _getColorForStatusCode(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return Colors.green;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.blue;
    } else if (statusCode >= 400 && statusCode < 500) {
      return Colors.orange;
    } else if (statusCode >= 500 && statusCode < 600) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  Color _getColorForGroup(String group) {
    switch (group) {
      case "2xx Success":
        return Colors.green;
      case "3xx Redirection":
        return Colors.blue;
      case "4xx Client Errors":
        return Colors.orange;
      case "5xx Server Errors":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
