import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../model/nodeConfig/nodeConfig.dart';
import '../../../repository/nodeConfig_repo.dart';
import 'getNodeConfig_event.dart';
import 'getNodeConfig_state.dart';

// the AuthBloc contain AuthEvents class and AuthState class
class GetAllNodeConfigBloc extends Bloc<GetAllNodeConfigEvent, GetAllNodeConfigState> {

  final NodeConfigRepository nodeConfigRepository = NodeConfigRepository();

  GetAllNodeConfigBloc() : super(GetAllNodeConfigInitial()) {

    on<GetAllNodeConfigList>((event, emit) async {
      try {
        emit(GetAllNodeConfigLoading());
        final List<NodeConfig> nodeConfigList = await nodeConfigRepository
            .getAllNodeConfigs();
        emit(GetAllNodeConfigLoaded(nodeConfigList: nodeConfigList));

        if (nodeConfigList[0].error != "") {
          emit(GetAllNodeConfigError(
              error: nodeConfigList[0].error));
        }
      } on http.ClientException {
        emit(const GetAllNodeConfigError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
