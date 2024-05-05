import 'package:equatable/equatable.dart';

import '../../../model/container/container.dart';

class GetContainerEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class StartLoadContainer extends GetContainerEvent {
  String containerId;
  StartLoadContainer({ required this.containerId });
}

class UpdateButtonPressed extends GetContainerEvent {
  ContainerModel container;
  UpdateButtonPressed({ required this.container });
}