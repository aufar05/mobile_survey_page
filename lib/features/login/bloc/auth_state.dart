part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final String message;
  final String authToken;

  AuthSuccessState({required this.message, required this.authToken});
}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState({required this.error});
}
