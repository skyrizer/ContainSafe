import 'dart:io';

import 'package:containsafe/model/httpResponse/httpResponse.dart';
import 'package:equatable/equatable.dart';

class GetHttpResponsesState extends Equatable {
  const GetHttpResponsesState();
  @override
  List<Object> get props => [];
}

class GetHttpResponsesInitial extends GetHttpResponsesState { }

class GetHttpResponsesLoading extends GetHttpResponsesState { }

class GetHttpResponsesLoaded extends GetHttpResponsesState {
  final List<HttpResponse> httpResponses;
  const GetHttpResponsesLoaded({required this.httpResponses});
}

class GetHttpResponsesError extends GetHttpResponsesState {
  final String? error;
  const GetHttpResponsesError({required this.error});
}

class GetHttpResponsesEmpty extends GetHttpResponsesState {}