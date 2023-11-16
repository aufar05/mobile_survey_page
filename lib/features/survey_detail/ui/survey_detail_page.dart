import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../bloc/survey_detail_bloc.dart';
import '../model/survey_answer.dart';

class SurveyDetailPage extends StatefulWidget {
  final String surveyId;

  const SurveyDetailPage({Key? key, required this.surveyId}) : super(key: key);

  @override
  State<SurveyDetailPage> createState() => _SurveyDetailPageState();
}

class _SurveyDetailPageState extends State<SurveyDetailPage> {
  int currentQuestionIndex = 0;
  PageController _pageController = PageController();
  TextEditingController textController = TextEditingController();
  List<SurveyAnswer> userAnswers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocBuilder<SurveyDetailBloc, SurveyDetailState>(
          builder: (context, state) {
            if (state is SurveyDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SurveyDetailLoaded) {
              final surveyDetail = state.surveyDetail;

              if (currentQuestionIndex >= surveyDetail.questions.length) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emoji_emotions),
                    Text('Terimakasih telah menyelesaikan survei.'),
                  ],
                ));
              }

              final currentQuestion =
                  surveyDetail.questions[currentQuestionIndex];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: Colors.blue)),
                              child: Text(
                                '99 Second Left',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    final pageCount =
                                        (surveyDetail.questions.length / 20)
                                            .ceil();
                                    //buat popout list pertanyaan
                                    return AlertDialog(
                                      title: Text('Survey Question'),
                                      content: Container(
                                        width: double.maxFinite,
                                        height: 320,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: PageView.builder(
                                                controller: _pageController,
                                                itemCount: pageCount,
                                                itemBuilder:
                                                    (context, pageIndex) {
                                                  return GridView.builder(
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      crossAxisSpacing: 8.0,
                                                      mainAxisSpacing: 8.0,
                                                    ),
                                                    itemCount: surveyDetail
                                                                    .questions
                                                                    .length -
                                                                pageIndex * 20 >
                                                            20
                                                        ? 20
                                                        : surveyDetail.questions
                                                                .length %
                                                            20,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final questionIndex =
                                                          pageIndex * 20 +
                                                              index;
                                                      final question =
                                                          surveyDetail
                                                                  .questions[
                                                              questionIndex];
                                                      final isRadioAnswered =
                                                          getSelectedOptionValue(
                                                                  question
                                                                      .id) !=
                                                              null;
                                                      final isTextAnswered =
                                                          questionIndex ==
                                                                  surveyDetail
                                                                          .questions
                                                                          .length -
                                                                      1 &&
                                                              textController
                                                                  .text
                                                                  .isNotEmpty;
                                                      final isSelected =
                                                          isRadioAnswered ||
                                                              isTextAnswered;
                                                      final isCurrentQuestion =
                                                          questionIndex ==
                                                              currentQuestionIndex;

                                                      return isCurrentQuestion
                                                          ? OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                setState(() {
                                                                  currentQuestionIndex =
                                                                      questionIndex;
                                                                });
                                                              },
                                                              child: Text(
                                                                '${questionIndex + 1}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                            )
                                                          : isSelected
                                                              ? ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    setState(
                                                                        () {
                                                                      currentQuestionIndex =
                                                                          questionIndex;
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      '${questionIndex + 1}'),
                                                                )
                                                              : OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    setState(
                                                                        () {
                                                                      currentQuestionIndex =
                                                                          questionIndex;
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      '${questionIndex + 1}'),
                                                                );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            SmoothPageIndicator(
                                              controller: _pageController,
                                              count: pageCount,
                                              effect: WormEffect(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.list_alt, color: Colors.white),
                              label: Text(
                                '${currentQuestionIndex + 1}/${surveyDetail.questions.length}',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          ' ${surveyDetail.surveyName}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                            '${currentQuestionIndex + 1}. ${currentQuestion.questionName}',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54)),
                      ],
                    ),
                  ),
                  Divider(thickness: 10, color: Colors.blue[50]),
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Answer',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 1, color: Colors.black12),
                  for (var option in currentQuestion.options)
                    SizedBox(
                      height: 40,
                      child: RadioListTile<int>(
                        title: Text(option.optionName),
                        value: option.value,
                        groupValue: getSelectedOptionValue(currentQuestion.id),
                        onChanged: (value) {
                          updateAnswer(currentQuestion.id, value);
                        },
                      ),
                    ),
                  if (currentQuestionIndex == surveyDetail.questions.length - 1)
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                          labelText: 'Jawaban Anda',
                        ),
                        onChanged: (value) {
                          updateAnswer(currentQuestion.id, null,
                              textAnswer: value);
                        },
                      ),
                    ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: OutlinedButton(
                            onPressed: currentQuestionIndex > 0
                                ? () {
                                    setState(() {
                                      currentQuestionIndex--;
                                    });
                                  }
                                : null,
                            child: Text('Back'),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentQuestionIndex++;
                              });
                            },
                            child: Text('Next'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is SurveyDetailError) {
              return Text('Error: ${state.errorMessage}');
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  int? getSelectedOptionValue(String questionId) {
    final answer = userAnswers.firstWhere(
      (answer) => answer.answers.any((ans) => ans.questionId == questionId),
      orElse: () => SurveyAnswer(
        surveyId: widget.surveyId,
        answers: [Answer(questionId: questionId, answer: '')],
      ),
    );

    return answer.answers.isNotEmpty
        ? int.tryParse(answer.answers.first.answer)
        : null;
  }

  void updateAnswer(String questionId, int? value, {String? textAnswer}) {
    setState(() {
      final index = userAnswers.indexWhere(
        (answer) => answer.answers.any((ans) => ans.questionId == questionId),
      );

      if (index != -1) {
        final answerIndex = userAnswers[index].answers.indexWhere(
              (ans) => ans.questionId == questionId,
            );

        if (answerIndex != -1) {
          if (value != null) {
            userAnswers[index].answers[answerIndex] = Answer(
              questionId: questionId,
              answer: value.toString(),
            );
          } else {
            userAnswers[index].answers[answerIndex] = Answer(
              questionId: questionId,
              answer: textAnswer ?? '',
            );
          }
        }
      } else {
        if (value != null) {
          userAnswers.add(SurveyAnswer(
            surveyId: widget.surveyId,
            answers: [
              Answer(
                questionId: questionId,
                answer: value.toString(),
              ),
            ],
          ));
        } else {
          userAnswers.add(SurveyAnswer(
            surveyId: widget.surveyId,
            answers: [
              Answer(
                questionId: questionId,
                answer: textAnswer ?? '',
              ),
            ],
          ));
        }
      }
    });
  }
}
