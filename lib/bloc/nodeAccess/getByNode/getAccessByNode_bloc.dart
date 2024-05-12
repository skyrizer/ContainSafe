import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../model/nodeAccess/nodeAccess.dart';
import '../../../repository/nodeAccess_repo.dart';
import 'getAccessByNode_event.dart';
import 'getAccessByNode_state.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class GetAccessByNodeBloc extends Bloc<GetAccessByNodeEvent, GetAccessByNodeState> {

  final NodeAccessRepository nodeAccessRepository = NodeAccessRepository();

  GetAccessByNodeBloc() : super(GetAccessByNodeInitial()) {

    on<GetAccessByNodeList>((event, emit) async {
      try {
        emit(GetAccessByNodeLoading());
        final List<NodeAccess> nodeAccessList = await nodeAccessRepository
            .getAccessByNode(event.nodeId);
        emit(GetAccessByNodeLoaded(nodeAccessList: nodeAccessList));

        if (nodeAccessList[0].error != "") {
          emit(GetAccessByNodeError(
              error: nodeAccessList[0].error));
        }
      } on http.ClientException {
        emit(const GetAccessByNodeError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
