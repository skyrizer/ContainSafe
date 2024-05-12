import 'package:containsafe/model/node/node.dart';
import 'package:equatable/equatable.dart';

import '../../../model/role/role.dart';
import '../../../model/user/user.dart';

class GetAllUserState extends Equatable {
  const GetAllUserState();
  @override
  List<Object> get props => [];
}

class GetAllUserInitial extends GetAllUserState { }

class GetAllUserLoading extends GetAllUserState { }

class GetAllUserLoaded extends GetAllUserState {
  final List<User> userList;
  const GetAllUserLoaded({required this.userList});
}

class GetAllUserError extends GetAllUserState {
  final String? error;
  const GetAllUserError({required this.error});
}

class GetAllUserEmpty extends GetAllUserState {}