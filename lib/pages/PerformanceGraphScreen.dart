import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../bloc/container/performanceWS/performanceWS_bloc.dart';
import '../bloc/container/performanceWS/performanceWS_state.dart';
import '../model/performance/performanceWS.dart';

class PerformanceGraphScreen extends StatefulWidget {
  final PerformanceWSBloc performanceWSBloc;
  final String containerName;

  PerformanceGraphScreen({
    required this.performanceWSBloc,
    required this.containerName,
  });

  @override
  _PerformanceGraphScreenState createState() => _PerformanceGraphScreenState();
}

class _PerformanceGraphScreenState extends State<PerformanceGraphScreen> {
  List<_ChartData> cpuData = [];
  List<_ChartData> memoryData = [];
  List<_ChartData> diskData = [];
  List<_ChartData> networkData = [];

  String? _highlighted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Graphs'),
        centerTitle: true,
      ),
      body: BlocBuilder<PerformanceWSBloc, PerformanceWSState>(
        bloc: widget.performanceWSBloc, // Ensure this is the correct bloc
        builder: (context, state) {
          if (state is PerformanceWSLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PerformanceWSError) {
            return Center(child: Text('Failed to load performance data'));
          } else if (state is PerformanceWSLoaded) {
            // Filter performance list for the selected container
            List filteredPerformanceList = state.performanceList
                .where((performance) => performance.containerName == widget.containerName)
                .toList();

            if (filteredPerformanceList.isEmpty) {
              return Center(child: Text("No Data Available for ${widget.containerName}"));
            }

            // Update the chart data with the filtered list
            _updateChartData(filteredPerformanceList);

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildChart(cpuData, 'CPU Usage(%) Over time', Colors.blue, 'CPU'),
                  _buildChart(memoryData, 'Memory Usage(%) Over time', Colors.green, 'Memory'),
                  _buildChart(diskData, 'Disk Usage', Colors.red, 'Disk'),
                  _buildChart(networkData, 'Network Usage', Colors.orange, 'Network'),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildChart(List<_ChartData> data, String title, Color color, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat('HH:mm:ss'),
              ),
              series: <ChartSeries<_ChartData, DateTime>>[
                LineSeries<_ChartData, DateTime>(
                  dataSource: data,
                  xValueMapper: (_ChartData data, _) => data.time,
                  yValueMapper: (_ChartData data, _) => data.value,
                  color: _highlighted == type ? color : color.withOpacity(0.2),
                  name: title,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateChartData(List filteredPerformanceList) {
    final DateTime now = DateTime.now();

    if (filteredPerformanceList.isNotEmpty) {
      final last = filteredPerformanceList.last;

      cpuData.add(_ChartData(now, _parsePercentage(last.cpuUsage)));
      memoryData.add(_ChartData(now, _calculateMemoryUsage(last)));
      diskData.add(_ChartData(now, _calculateDiskUsage(last)));
      networkData.add(_ChartData(now, _calculateNetworkUsage(last)));

      if (cpuData.length > 100) {
        cpuData.removeAt(0);
        memoryData.removeAt(0);
        diskData.removeAt(0);
        networkData.removeAt(0);
      }
    }
  }

  double _parsePercentage(String percentageString) {
    return double.tryParse(percentageString.replaceAll('%', '').trim()) ?? 0.0;
  }

  double _calculateMemoryUsage(PerformanceWS performance) {
    final last = performance; // Assuming 'performance' is of type PerformanceWS
    double memUsageBytes = _parseAndConvertToBytes(last.memUsage);
    double memSizeBytes = _parseAndConvertToBytes(last.memSize);
    double percentage = (memUsageBytes / memSizeBytes) * 100;
    return double.parse(percentage.toStringAsFixed(2));
  }

  double _calculateDiskUsage(PerformanceWS performance) {
    final last = performance; // Assuming 'performance' is of type PerformanceWS
    double blockInputBytes = _parseAndConvertToBytes(last.blockInput);
    double blockOutputBytes = _parseAndConvertToBytes(last.blockOutput);
    return blockInputBytes + blockOutputBytes;
  }

  double _calculateNetworkUsage(PerformanceWS performance) {
    final last = performance; // Assuming 'performance' is of type PerformanceWS
    double netInputBytes = _parseAndConvertToBytes(last.netInput);
    double netOutputBytes = _parseAndConvertToBytes(last.netOutput);
    return netInputBytes + netOutputBytes;
  }

  double _parseAndConvertToBytes(String memString) {
    final regex = RegExp(r'(\d+(\.\d+)?)');
    final match = regex.firstMatch(memString);
    if (match != null) {
      double value = double.parse(match.group(0)!);
      if (memString.toLowerCase().contains('kib')) {
        return value * 1024;
      } else if (memString.toLowerCase().contains('mib')) {
        return value * 1024 * 1024;
      } else if (memString.toLowerCase().contains('gib')) {
        return value * 1024 * 1024 * 1024;
      } else {
        return value;
      }
    } else {
      throw FormatException('Invalid memory string format: $memString');
    }
  }
}

class _ChartData {
  _ChartData(this.time, this.value);

  final DateTime time;
  final double value;
}
