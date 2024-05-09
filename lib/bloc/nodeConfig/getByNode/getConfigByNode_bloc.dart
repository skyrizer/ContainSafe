import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../model/nodeConfig/nodeConfig.dart';
import '../../../repository/nodeConfig_repo.dart';
import 'getConfigByNode_event.dart';
import 'getConfigByNode_state.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class GetConfigByNodeBloc extends Bloc<GetConfigByNodeEvent, GetConfigByNodeState> {

  final NodeConfigRepository nodeConfigRepository = NodeConfigRepository();

  GetConfigByNodeBloc() : super(GetConfigByNodeInitial()) {

    on<GetConfigByNodeList>((event, emit) async {
      try {
        emit(GetConfigByNodeLoading());
        final List<NodeConfig> nodeConfigList = await nodeConfigRepository
            .getConfigByNode(event.nodeId);
        emit(GetConfigByNodeLoaded(nodeConfigList: nodeConfigList));

        if (nodeConfigList[0].error != "") {
          emit(GetConfigByNodeError(
              error: nodeConfigList[0].error));
        }
      } on http.ClientException {
        emit(const GetConfigByNodeError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
