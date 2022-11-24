part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginHandle extends AuthEvent {
  final String? email;
  final String? password;

  const LoginHandle(this.email, this.password);
}

class RegisterHandle extends AuthEvent {
  final String? email;
  final String? password;

  const RegisterHandle(this.email, this.password);
}
