part of 'survey_detail_bloc.dart';

@immutable
abstract class SurveyDetailEvent {}

class LoadSurveyDetail extends SurveyDetailEvent {
  final String surveyId;

  LoadSurveyDetail({required this.surveyId});
}
