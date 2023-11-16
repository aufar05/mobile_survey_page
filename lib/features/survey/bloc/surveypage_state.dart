part of 'surveypage_bloc.dart';

@immutable
abstract class SurveypageState {}

abstract class SurveyActionState extends SurveypageState {}

class SurveypageInitial extends SurveypageState {}

class SurveypageLoading extends SurveypageState {}

class SurveypageLoaded extends SurveypageState {
  final List<SurveyModel> surveys;

  SurveypageLoaded({required this.surveys});
}

class SurveypageError extends SurveypageState {
  final String errorMessage;

  SurveypageError(this.errorMessage);
}
