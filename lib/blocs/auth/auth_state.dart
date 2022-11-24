part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailed extends AuthState {
  final String? email;
  final String? password;

  const LoginFailed(this.email, this.password);
}

class LoginUnauthorized extends AuthState {}

class RegisterSuccess extends AuthState {}

class RegisterFailed extends AuthState {
  final String? email;
  final String? password;

  const RegisterFailed(this.email, this.password);
}
