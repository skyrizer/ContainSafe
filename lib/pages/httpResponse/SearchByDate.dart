import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:containsafe/model/httpResponse/httpResponse.dart';
import 'package:fl_chart/fl_chart.dart';

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
            return _buildChart();
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

  Widget _buildChart() {
    Map<int, int> statusCodeCounts = {};
    for (var response in httpResponselist) {
      statusCodeCounts[response.statusCode] = (statusCodeCounts[response.statusCode] ?? 0) + 1;
    }

    List<BarChartGroupData> barChartData = statusCodeCounts.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            y: entry.value.toDouble(), // Adjust 'y' to 'toY' for the latest API
            width: 15,
            //color: _getColorForStatusCode(entry.key), // Optional: Color coding based on status code
          ),
        ],
      );
    }).toList();

    double maxY = statusCodeCounts.values.isEmpty ? 0 : statusCodeCounts.values.reduce((a, b) => a > b ? a : b).toDouble();

    return Padding(
      padding: EdgeInsets.all(16.0), // Use EdgeInsets to provide padding around the chart
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.5, // Adjust based on desired width-to-height ratio
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY + 1000, // Ensure the Y-axis includes the highest value plus a buffer
              barGroups: barChartData,
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  margin: 10,
                  interval: 1000, // Label intervals on the Y-axis
                  // getTitlesWidget: (value, meta) {
                  //   return Text(
                  //     value.toInt().toString(),
                  //     style: TextStyle(fontSize: 14, color: Colors.black),
                  //   );
                  // },
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  margin: 10,
                  // getTitlesWidget: (value, meta) {
                  //   return Text(
                  //     value.toInt().toString(),
                  //     style: TextStyle(fontSize: 14, color: Colors.black),
                  //   );
                  // },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
