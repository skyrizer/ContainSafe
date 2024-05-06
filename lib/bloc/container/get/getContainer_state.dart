import 'package:equatable/equatable.dart';
import '../../../model/container/container.dart';

class GetContainerState extends Equatable{
  @override
  List<Object> get props => [];
}
class GetContainerInitState extends GetContainerState {}

class GetContainerLoadedState extends GetContainerState {
  final ContainerModel containerData;
  GetContainerLoadedState({required this.containerData});
}


class GetContainerLoadingState extends GetContainerState {}

class GetContainerErrorState extends GetContainerState {
  final message;
  GetContainerErrorState({required this.message});
}


class GetContainerUpdating extends GetContainerState {}

class GetContainerUpdated extends GetContainerState {}