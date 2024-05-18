import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:containsafe/bloc/container/performanceWS/performanceWS_event.dart';
import 'package:containsafe/bloc/container/performanceWS/performanceWS_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../model/performance/performanceWS.dart';

class PerformanceWSBloc extends Bloc<PerformanceWSEvent, PerformanceWSState> {
  late WebSocketChannel _channel;
  StreamSubscription? _subscription;

  PerformanceWSBloc() : super(PerformanceWSLoading()) {
    on<LoadPerformanceWSData>(_startListening);
  }

  Future<void> _startListening(LoadPerformanceWSData event, Emitter<PerformanceWSState> emit) async {
    final String wsUrl = 'ws://${event.ipAddress}:8080'; // Construct WebSocket URL using the IP address
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    await emit.forEach(
      _channel.stream,
      onData: (data) {
        try {
          final performanceData = json.decode(data)['performance'] as List;
          if (performanceData != []) {
            final performanceList = performanceData
                .map((item) => PerformanceWS.fromJson(item))
                .toList();
            return PerformanceWSLoaded(performanceList);
          }
          return PerformanceWSEmpty();
        } catch (error) {
          return PerformanceWSError(error.toString());
        }
      },
      onError: (error, stackTrace) {
        return PerformanceWSError(error.toString());
      },
    );

    await _channel.sink.close();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _channel.sink.close();
    return super.close();
  }
}
