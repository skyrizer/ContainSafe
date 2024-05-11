import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../model/config/config.dart';
import '../../../repository/config_repo.dart';
import 'getConfig_event.dart';
import 'getConfig_state.dart';

class GetAllConfigBloc extends Bloc<GetAllConfigEvent, GetAllConfigState> {

  final ConfigRepository configRepository = ConfigRepository();

  GetAllConfigBloc() : super(GetAllConfigInitial()) {

    on<GetAllConfigList>((event, emit) async {
      try {
        emit(GetAllConfigLoading());
        final List<Config> configList = await configRepository
            .getAllConfigs();
        emit(GetAllConfigLoaded(configList: configList));

        if (configList[0].error != "") {
          emit(GetAllConfigError(
              error: configList[0].error));
        }
      } on http.ClientException {
        emit(const GetAllConfigError(
            error: "Failed to fetch data in your device online"));
      }
    });


  }
}
