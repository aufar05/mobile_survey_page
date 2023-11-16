import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_survei_page/features/survey/bloc/surveypage_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_survei_page/features/survey_detail/ui/survey_detail_page.dart';

import '../../login/bloc/auth_bloc.dart';
import '../../survey_detail/bloc/survey_detail_bloc.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  late SurveypageBloc surveypageBloc;
  String? selectedSurveyId;

  @override
  void initState() {
    super.initState();
    surveypageBloc =
        SurveypageBloc(authBloc: BlocProvider.of<AuthBloc>(context));
    surveypageBloc.add(LoadSurveys());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Halaman Survey',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutEvent());

                      Navigator.of(context).pushReplacementNamed('/auth');
                    },
                    icon: const Icon(Icons.logout),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              BlocConsumer<SurveypageBloc, SurveypageState>(
                bloc: surveypageBloc,
                listenWhen: (previous, current) =>
                    current is SurveypageLoaded || current is SurveypageError,
                listener: (context, state) {
                  if (state is SurveypageError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${state.errorMessage}'),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is SurveypageLoaded) {
                    final loadedState = state;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: loadedState.surveys.length,
                        itemBuilder: (context, index) {
                          final survey = loadedState.surveys[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSurveyId = survey.id;
                              });
                              BlocProvider.of<SurveyDetailBloc>(context).add(
                                LoadSurveyDetail(surveyId: selectedSurveyId!),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SurveyDetailPage(
                                          surveyId: selectedSurveyId!,
                                        )),
                              );
                              print('ini adalah idnya : $selectedSurveyId');
                            },
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.black, width: 0.1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              leading: const Icon(
                                Icons.assignment_rounded,
                                size: 48,
                                color: Colors.blue,
                              ),
                              title: Text(survey.surveyName),
                              subtitle: Text(
                                'Created at: ${formatDate(survey.createdAt)}',
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is SurveypageLoading) {
                    return const CircularProgressIndicator();
                  } else {
                    return Container(
                      child: const Text('Error or other state'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatDate(DateTime dateTime) {
  final formatter = DateFormat('d MMMM y', 'id_ID');
  return formatter.format(dateTime);
}
