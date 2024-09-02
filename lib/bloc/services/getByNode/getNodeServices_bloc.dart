import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../model/service/service_status.dart';
import 'getNodeServices_event.dart';
import 'getNodeServices_state.dart';

class GetNodeServicesBloc extends Bloc<GetNodeServicesEvent, GetNodeServicesState> {
  late WebSocketChannel _channel;
  StreamSubscription? _subscription;

  GetNodeServicesBloc() : super(GetServicesLoading()) {
    on<LoadGetServicesData>(_startListening);
  }

  Future<void> _startListening(LoadGetServicesData event, Emitter<GetNodeServicesState> emit) async {
    final String wsUrl = 'ws://${event.ipAddress}:8765'; // Construct WebSocket URL using the IP address
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    await emit.forEach(
      _channel.stream,
      onData: (data) {
        try {
          final Map<String, dynamic> jsonData = json.decode(data);

          // Check if the data is of type 'service_status'
          if (jsonData.containsKey('service_status')) {
            final List<dynamic> serviceStatusList = jsonData['service_status'];

            if (serviceStatusList.isNotEmpty) {
              final List<ServiceStatus> statusList = serviceStatusList
                  .map((status) => ServiceStatus.fromJson(status))
                  .toList();
              return GetServicesLoaded(statusList);
            } else {
              return GetServicesEmpty();
            }
          }

          // If it's not a 'service_status' type, ignore it
          return state;
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
