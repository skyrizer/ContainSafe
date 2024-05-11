import 'package:equatable/equatable.dart';

import '../../../model/config/config.dart';
import '../../../model/container/container.dart';

class EditConfigEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class UpdateConfigButtonPressed extends EditConfigEvent {
  Config config;
  UpdateConfigButtonPressed({ required this.config });
}