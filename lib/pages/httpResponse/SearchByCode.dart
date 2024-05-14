import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:containsafe/model/httpResponse/httpResponse.dart';

import '../../bloc/httpResponse/searchByNode/searchByCode_bloc.dart';
import '../../bloc/httpResponse/searchByNode/searchByCode_event.dart';
import '../../bloc/httpResponse/searchByNode/searchByCode_state.dart';

class SearchByCodeView extends StatefulWidget {
  const SearchByCodeView({super.key});

  @override
  State<SearchByCodeView> createState() => _SearchByCodeViewState();
}

class _SearchByCodeViewState extends State<SearchByCodeView> {

  TextEditingController statusCodeController = TextEditingController();
  List<HttpResponse> httpResponselist = [];
  late SearchByCodeBloc searchByCodeBloc;

  @override
  void initState() {
    super.initState();
    searchByCodeBloc = BlocProvider.of<SearchByCodeBloc>(context);
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
                statusCodeField(),
                IconButton(onPressed: () {
                  if (statusCodeController.text.isNotEmpty) {
                    searchByCodeBloc.add(SearchByCodePressed(statusCode: int.parse(statusCodeController.text.trim())));
                  }
                }, icon: const Icon(Icons.search)),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchByCodeBloc, SearchByCodeState>(
        builder: (context, state) {
          if (state is SearchByCodeLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: HexColor("#3c1e08"),
              ),
            );
          } else if (state is SearchByCodeLoadedState) {
            httpResponselist = state.searchByCodeList;
            return _resultList();
          } else if (state is SearchByCodeErrorState) {
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

  Widget statusCodeField() {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: 270,
      child: TextFormField(
        controller: statusCodeController,
        decoration: InputDecoration(
          hintText: "Enter Status Code",
          focusColor: HexColor("#3c1e08"),
        ),
        onChanged: (text) {
          if (text.isNotEmpty) {
            searchByCodeBloc.add(SearchByCodePressed(statusCode: int.parse(text.trim())));
          }
        },
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
