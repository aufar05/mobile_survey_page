class SurveyModel {
  final String id;
  final String surveyName;
  final int status;
  final int totalRespondent;
  final DateTime createdAt;
  final DateTime updatedAt;

  SurveyModel({
    required this.id,
    required this.surveyName,
    required this.status,
    required this.totalRespondent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SurveyModel.fromMap(Map<String, dynamic> map) {
    return SurveyModel(
      id: map['id'] as String,
      surveyName: map['survey_name'] as String,
      status: map['status'] as int,
      totalRespondent: map['total_respondent'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}

class QuestionModel {
  final String questionName;
  final String inputType;
  final String questionId;

  QuestionModel({
    required this.questionName,
    required this.inputType,
    required this.questionId,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      questionName: map['question_name'] as String,
      inputType: map['input_type'] as String,
      questionId: map['question_id'] as String,
    );
  }
}
