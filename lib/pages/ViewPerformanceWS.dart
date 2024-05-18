import 'package:containsafe/repository/APIConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/container/performanceWS/performanceWS_bloc.dart';
import '../bloc/container/performanceWS/performanceWS_event.dart';
import '../bloc/container/performanceWS/performanceWS_state.dart';

class ViewPerformaceWSScreen extends StatefulWidget {
  @override
  _ViewPerformaceWSState createState() => _ViewPerformaceWSState();
}

class _ViewPerformaceWSState extends State<ViewPerformaceWSScreen> {
  late PerformanceWSBloc _performanceWSBloc;

  @override
  void initState() {
    super.initState();
    _performanceWSBloc = PerformanceWSBloc()..add(LoadPerformanceWSData("192.168.0.115"));
  }

  @override
  void dispose() {
    _performanceWSBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _performanceWSBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Docker Performance'),
        ),
        body: BlocBuilder<PerformanceWSBloc, PerformanceWSState>(
          builder: (context, state) {
            if (state is PerformanceWSLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PerformanceWSLoaded) {
              return ListView.builder(
                itemCount: state.performanceList.length,
                itemBuilder: (context, index) {
                  final performance = state.performanceList[index];
                  return ListTile(
                    title: Text(performance.containerName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CPU Usage: ${performance.cpuUsage}'),
                        Text('Memory Usage: ${performance.memUsage}/${performance.memSize}'),
                        Text('Network: ${performance.netInput}/${performance.netOutput}'),
                        Text('Block: ${performance.blockInput}/${performance.blockOutput}'),
                        Text('PIDs: ${performance.pids}'),
                      ],
                    ),
                  );
                },
              );
            } else if (state is PerformanceWSError) {
              return Center(child: Text('Failed to load performance data'));
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
