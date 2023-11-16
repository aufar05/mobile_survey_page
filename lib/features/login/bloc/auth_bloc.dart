import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String? authToken;

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(loginEvent);
    on<LogoutEvent>(logoutEvent);
  }

  void logoutEvent(LogoutEvent event, Emitter<AuthState> emit) {
    authToken = null;
    emit(AuthInitial());
  }

  Future<void> loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      final response = await http.post(
        Uri.parse('https://panel-demo.obsight.com/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': event.email,
          'password': event.password,
        }),
      );

      if (response.statusCode == 200) {
        final String? token = response.headers['set-cookie'];

        if (token != null) {
          // mengekstrak token dari string header dan simpan
          final authToken = token.split('=')[1].split(';')[0];
          // Perbarui nilai authToken
          this.authToken = authToken;
          emit(AuthSuccessState(
              message: 'Berhasil login', authToken: authToken));
        }
      } else if (response.statusCode == 400) {
        emit(AuthErrorState(error: 'Email atau password salah'));
      } else {
        emit(AuthErrorState(error: 'Gagal login'));
      }
    } catch (error) {
      emit(AuthErrorState(error: 'Tidak ada Koneksi Internet'));
    }
  }

  String? getToken() => authToken;
}
