import 'package:equatable/equatable.dart';

import '../../../model/node/node.dart';

class EditNodeEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class UpdateNodeButtonPressed extends EditNodeEvent {
  Node node;
  UpdateNodeButtonPressed({ required this.node });
}