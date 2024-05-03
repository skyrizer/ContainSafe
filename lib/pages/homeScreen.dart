import 'package:containsafe/bloc/container/performance/performance_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../bloc/container/performance/performance_event.dart';
import '../bloc/container/performance/performance_state.dart';
import 'dart:async';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PerformanceBloc _performanceBloc = PerformanceBloc();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _performanceBloc.add(GetAllPerformanceList()); // Dispatch the event here

    // Start a timer to fetch data every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _performanceBloc.add(GetAllPerformanceList());
    });

  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _performanceBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 8.0,
              ),
              Text('ContainSafe', style: Theme.of(context).textTheme.bodyLarge)
            ],
          ),
          backgroundColor: HexColor("#ecd9c9"),
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: _buildListPerformance(),
      ),
    );
  }

  Widget _buildListPerformance() {
    return Container(
      color: HexColor("#ecd9c9"),
      child: BlocProvider(
        create: (context) => _performanceBloc,
        child: BlocBuilder<PerformanceBloc, PerformanceState>(
          builder: (context, state) {
            if (state is GetAllPerformanceError) {
              return Center(
                child: Text(state.error ?? "Error loading data"),
              );
            } else if (state is GetAllPerformanceInitial ||
                state is GetAllPerformanceLoading) {
              return Center(
                child: CircularProgressIndicator(color: HexColor("#3c1e08")),
              );
            } else if (state is GetAllPerformanceLoaded) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context)
                      .colorScheme
                      .copyWith(primary: HexColor("#3c1e08")),
                ),
                child: ListView.builder(
                  itemCount: state.allPerformanceList.length,
                  itemBuilder: (context, index) {
                    final performance = state.allPerformanceList[index];
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
                            performance.containerName,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),

                          _buildPerformanceDataList(
                              performance.diskUsage, "Disk Usage"),
                          _buildPerformanceDataList(
                              performance.cpuUsage, "CPU Usage"),
                          _buildPerformanceDataList(
                              performance.memoryUsage, "Memory Usage"),
                          _buildPerformanceDataList(
                              performance.networkUsage, "Network Usage"),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return SizedBox
                .shrink(); // Return an empty widget if none of the conditions match
          },
        ),
      ),
    );
  }

  Widget _buildPerformanceDataList(
      List<Map<String, dynamic>> data, String title) {
    if (data.isEmpty) {
      return SizedBox.shrink();
    }

    // Sort the data by dateTime in descending order
    data.sort((a, b) =>
        DateTime.parse(b['dateTime']).compareTo(DateTime.parse(a['dateTime'])));

    // Take only the first item (latest data point)
    final latestData = data.isNotEmpty ? data[0] : null;

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          // Text(
          //   title,
          //   style: TextStyle(
          //     fontSize: 20.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // SizedBox(height: 10.0),
          if (latestData != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Column(
                //   children: [
                if (title == 'Disk Usage')
                  _buildDiskUsageContainer(latestData),
                if (title == 'CPU Usage')
                  _buildCpuUsageContainer(latestData),
                //   ],
                // ),
                // Column(
                //   children: [
                if (title == 'Network Usage')
                  _buildNetworkUsageContainer(latestData),
                if (title == 'Memory Usage')
                  _buildMemoryUsageContainer(latestData),
                //   ],
                // ),
              ],
            ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }


  Widget _buildMemoryUsageContainer(Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Memory Usage',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'Usage: ${data['usage']}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'Size: ${data['size']}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkUsageContainer(Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Network Usage',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'Input: ${data['input']}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'Output: ${data['output']}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCpuUsageContainer(Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CPU Usage',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'Percentage: ${data['percentage']}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiskUsageContainer(Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disk Usage',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'Input: ${data['input']}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'Output: ${data['output']}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }


}