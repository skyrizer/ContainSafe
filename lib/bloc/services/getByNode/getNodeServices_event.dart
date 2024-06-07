import 'package:equatable/equatable.dart';

abstract class GetNodeServicesEvent extends Equatable {
  const GetNodeServicesEvent();

  @override
  List<Object> get props => [];
}

class LoadGetServicesData extends GetNodeServicesEvent {
  final String ipAddress;

  const LoadGetServicesData(this.ipAddress);
}
