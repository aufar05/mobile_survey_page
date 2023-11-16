part of 'surveypage_bloc.dart';

@immutable
abstract class SurveypageEvent {}

class LoadSurveys extends SurveypageEvent {}

class SelectSurvey extends SurveypageEvent {
  final String surveyId;

  SelectSurvey({required this.surveyId});
}
