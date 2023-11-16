import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_survei_page/features/login/ui/login_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'features/login/bloc/auth_bloc.dart';
import 'features/survey/bloc/surveypage_bloc.dart';
import 'features/survey/ui/survey_page.dart';
import 'features/survey_detail/bloc/survey_detail_bloc.dart';

void main() async {
  await initializeDateFormatting('id_ID', null);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<SurveypageBloc>(
          create: (context) =>
              SurveypageBloc(authBloc: BlocProvider.of<AuthBloc>(context)),
        ),
        BlocProvider<SurveyDetailBloc>(
          create: (context) =>
              SurveyDetailBloc(authBloc: BlocProvider.of<AuthBloc>(context)),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/auth': (context) => LoginPage(),
        '/surveyPage': (context) => SurveyPage(),
      },
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
