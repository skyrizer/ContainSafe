import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:containsafe/model/httpResponse/httpResponse.dart';

import '../../bloc/httpResponse/searchByDate/searchByDate_bloc.dart';
import '../../bloc/httpResponse/searchByDate/searchByDate_event.dart';
import '../../bloc/httpResponse/searchByDate/searchByDate_state.dart';
import '../../bloc/httpResponse/searchByNode/searchByCode_bloc.dart';
import '../../bloc/httpResponse/searchByNode/searchByCode_event.dart';
import '../../bloc/httpResponse/searchByNode/searchByCode_state.dart';

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
          if (state is SearchByCodeLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: HexColor("#3c1e08"),
              ),
            );
          } else if (state is SearchByDateLoadedState) {
            httpResponselist = state.searchByDateList;
            return _resultList();
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

  Widget _resultList() {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: ListView.builder(
        itemCount: httpResponselist.length,
        itemBuilder: (context, index) {
          HttpResponse response = httpResponselist[index];
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Code: ${response.statusCode}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Method: ${response.method}',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'URL: ${response.url}',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'IP Address: ${response.ipAddress}',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                // You can add more fields here as needed
              ],
            ),
          );
        },
      ),
    );
  }
}
