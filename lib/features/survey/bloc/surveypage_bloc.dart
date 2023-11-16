import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile_survei_page/features/login/bloc/auth_bloc.dart';
import 'package:mobile_survei_page/features/survey/model/survey_model.dart';
import 'package:http/http.dart' as http;

part 'surveypage_event.dart';
part 'surveypage_state.dart';

class SurveypageBloc extends Bloc<SurveypageEvent, SurveypageState> {
  final AuthBloc authBloc;

  SurveypageBloc({required this.authBloc}) : super(SurveypageInitial()) {
    on<LoadSurveys>(loadSurveys);
    on<SelectSurvey>(selectSurvey);
  }

  List<SurveyModel> parseSurveys(String responseBody) {
    final parsed = json.decode(responseBody);

    final List<dynamic> surveyList = parsed['data'];
    return surveyList.map((survey) => SurveyModel.fromMap(survey)).toList();
  }

  FutureOr<void> loadSurveys(
      LoadSurveys event, Emitter<SurveypageState> emit) async {
    final token = authBloc.getToken();
    if (token == null) {
      emit(SurveypageError('Token is null'));
      return;
    }

    try {
      emit(SurveypageLoading());

      final response = await http.get(
        Uri.parse('https://panel-demo.obsight.com/api/survey'),
        headers: {
          'Cookie': 'token=$token',
        },
      );

      if (response.statusCode == 200) {
        final List<SurveyModel> surveys = parseSurveys(response.body);
        emit(SurveypageLoaded(surveys: surveys));
      } else {
        emit(SurveypageError(
            'Failed to load surveys. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(SurveypageError('Failed to load surveys: $e'));
    }
  }

  FutureOr<void> selectSurvey(
      SelectSurvey event, Emitter<SurveypageState> emit) {}
}
