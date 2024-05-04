import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../repository/node_repo.dart';
import '/../model/node/node.dart';
import 'getAllNode_event.dart';
import 'getAllNode_state.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class GetAllNodeBloc extends Bloc<GetAllNodeEvent, GetAllNodeState> {

  final NodeRepository nodeRepository = NodeRepository();

  GetAllNodeBloc() : super(GetAllNodeInitial()) {

    on<GetAllNodeList>((event, emit) async {
      try {
        emit(GetAllNodeLoading());
        final List<Node> nodeList = await nodeRepository
            .getAllNodes();
        emit(GetAllNodeLoaded(nodeList: nodeList));

        if (nodeList[0].error != "") {
          emit(GetAllNodeError(
              error: nodeList[0].error));
        }
      } on http.ClientException {
        emit(const GetAllNodeError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
