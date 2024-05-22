import 'package:equatable/equatable.dart';

abstract class GetServicesEvent extends Equatable {
  const GetServicesEvent();

  @override
  List<Object> get props => [];
}

class LoadGetServicesData extends GetServicesEvent {
  final String ipAddress;

  const LoadGetServicesData(this.ipAddress);
}
