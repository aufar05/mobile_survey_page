class SurveyDetailModel {
  final String id;
  final String surveyName;
  final int status;
  final int totalRespondent;
  final String createdAt;
  final String updatedAt;
  final List<QuestionModel> questions;

  SurveyDetailModel({
    required this.id,
    required this.surveyName,
    required this.status,
    required this.totalRespondent,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory SurveyDetailModel.fromJson(Map<String, dynamic> json) {
    print('JSON to parse: $json');

    var questionsList = json['data']['questions'] as List;
    print('Questions List: $questionsList');

    List<QuestionModel> questions = questionsList.map((i) {
      print('Question JSON: $i');
      return QuestionModel.fromJson(i);
    }).toList();

    return SurveyDetailModel(
      id: json['data']['id'],
      surveyName: json['data']['survey_name'],
      status: json['data']['status'],
      totalRespondent: json['data']['total_respondent'],
      createdAt: json['data']['created_at'],
      updatedAt: json['data']['updated_at'],
      questions: questions,
    );
  }
}

class QuestionModel {
  final String id;
  final int questionNumber;
  final String surveyId;
  final String section;
  final String inputType;
  final String questionName;
  final String questionSubject;
  final List<OptionModel> options;

  QuestionModel({
    required this.id,
    required this.questionNumber,
    required this.surveyId,
    required this.section,
    required this.inputType,
    required this.questionName,
    required this.questionSubject,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    var optionsList = json['options'] as List?;
    List<OptionModel> options = [];

    if (optionsList != null) {
      options = optionsList.map((i) => OptionModel.fromJson(i)).toList();
    }

    return QuestionModel(
      id: json['id'],
      questionNumber: json['question_number'],
      surveyId: json['survey_id'],
      section: json['section'],
      inputType: json['input_type'],
      questionName: json['question_name'],
      questionSubject: json['question_subject'],
      options: options,
    );
  }
}

class OptionModel {
  final String id;
  final String questionId;
  final String optionName;
  final int value;
  final String color;

  OptionModel({
    required this.id,
    required this.questionId,
    required this.optionName,
    required this.value,
    required this.color,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'],
      questionId: json['question_id'],
      optionName: json['option_name'],
      value: json['value'],
      color: json['color'],
    );
  }
}
