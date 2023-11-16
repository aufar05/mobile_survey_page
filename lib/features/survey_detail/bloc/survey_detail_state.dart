part of 'survey_detail_bloc.dart';

@immutable
abstract class SurveyDetailState {}

class SurveyDetailInitial extends SurveyDetailState {}

class SurveyDetailLoading extends SurveyDetailState {}

class SurveyDetailLoaded extends SurveyDetailState {
  final SurveyDetailModel surveyDetail;

  SurveyDetailLoaded({required this.surveyDetail});
}

class SurveyDetailError extends SurveyDetailState {
  final String errorMessage;

  SurveyDetailError({required this.errorMessage});
}
