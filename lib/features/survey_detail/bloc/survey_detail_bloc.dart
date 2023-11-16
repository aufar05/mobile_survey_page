import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile_survei_page/features/survey_detail/model/survey_detail_model.dart';

import '../../login/bloc/auth_bloc.dart';

import 'package:http/http.dart' as http;

part 'survey_detail_event.dart';
part 'survey_detail_state.dart';

class SurveyDetailBloc extends Bloc<SurveyDetailEvent, SurveyDetailState> {
  final AuthBloc authBloc;

  SurveyDetailBloc({required this.authBloc}) : super(SurveyDetailInitial()) {
    on<LoadSurveyDetail>(loadSurveyDetail);
  }

  FutureOr<void> loadSurveyDetail(
      LoadSurveyDetail event, Emitter<SurveyDetailState> emit) async {
    final token = authBloc.getToken();
    final surveyId = event.surveyId;
    try {
      emit(SurveyDetailLoading());

      final response = await http.get(
        Uri.parse('https://panel-demo.obsight.com/api/survey/$surveyId'),
        headers: {
          'Cookie': 'token=$token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;

        print('JSON Response: $responseBody');

        try {
          final surveyDetail =
              SurveyDetailModel.fromJson(json.decode(responseBody));

          print('Survey Detail Model: $surveyDetail');

          emit(SurveyDetailLoaded(surveyDetail: surveyDetail));
        } catch (e) {
          print('Error parsing JSON: $e');
          emit(SurveyDetailError(errorMessage: 'Error parsing JSON'));
        }
      } else {
        emit(SurveyDetailError(errorMessage: 'Error'));
        print('Error');
      }
    } catch (e) {
      emit(SurveyDetailError(errorMessage: 'Failed to load surveys: $e'));
      print('Error parah');
    }
  }
}
