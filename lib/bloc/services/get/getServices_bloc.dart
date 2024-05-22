import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:containsafe/bloc/container/performanceWS/performanceWS_event.dart';
import 'package:containsafe/bloc/container/performanceWS/performanceWS_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../model/performance/performanceWS.dart';
import '../../../model/service/service_status.dart';
import 'getServices_event.dart';
import 'getServices_state.dart';

class GetServicesBloc extends Bloc<GetServicesEvent, GetServicesState> {
  late WebSocketChannel _channel;
  StreamSubscription? _subscription;

  GetServicesBloc() : super(GetServicesLoading()) {
    on<LoadGetServicesData>(_startListening);
  }

  Future<void> _startListening(LoadGetServicesData event, Emitter<GetServicesState> emit) async {
    final String wsUrl = 'ws://${event.ipAddress}:8765'; // Construct WebSocket URL using the IP address
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    await emit.forEach(
      _channel.stream,
      onData: (data) {
        try {
          final Map<String, dynamic> serviceStatus = json.decode(data)['service_status'];
          if (serviceStatus.isNotEmpty) {
            final status = ServiceStatus.fromJson(serviceStatus);
            return GetServicesLoaded([status]);
          }
          return GetServicesEmpty();
        } catch (error) {
          return GetServicesError(error.toString());
        }
      },
      onError: (error, stackTrace) {
        return GetServicesError(error.toString());
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
