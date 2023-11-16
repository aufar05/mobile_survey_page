class SurveyAnswer {
  final String surveyId;
  final List<Answer> answers;

  SurveyAnswer({
    required this.surveyId,
    required this.answers,
  });
}

class Answer {
  final String questionId;
  final String answer;

  Answer({
    required this.questionId,
    required this.answer,
  });
}
