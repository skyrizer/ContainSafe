import 'package:equatable/equatable.dart';


class DeleteBpEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class StartDeleteBp extends DeleteBpEvents {}

class DeleteBpButtonPressed extends DeleteBpEvents{
  final int serviceId;
  final int bpId;


  DeleteBpButtonPressed({
    required this.serviceId,
    required this.bpId,
  });

}