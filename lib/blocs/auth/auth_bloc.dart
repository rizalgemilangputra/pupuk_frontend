import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pupuk_frontend/constants.dart';
import 'package:pupuk_frontend/repository/login_repository.dart';
import 'package:pupuk_frontend/repository/register_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginHandle>((event, emit) async {
      LoginRepository loginRepository = LoginRepository();
      LocalStorage localStorage = LocalStorage(AppConfig.localStorageName);

      try {
        emit(AuthLoading());

        if (event.email!.isEmpty ||
            event.password!.isEmpty ||
            event.password!.length < 6) {
          String? emailMessage;
          String? passwordMessage;
          if (event.email!.isEmpty) {
            emailMessage = 'Email tidak boleh kosong';
          }
          if (event.password!.isEmpty) {
            passwordMessage = 'Password tidak boleh kosong';
          } else if (event.password!.length < 6) {
            passwordMessage = 'Password tidak boleh kurang dari 6 karakter';
          }

          emit(LoginFailed(emailMessage, passwordMessage));
        } else {
          Map<String, dynamic> req = {
            "email": event.email,
            "password": event.password
          };
          dynamic res = await loginRepository.login(req);
          if (res['code'] == 200) {
            await localStorage.setItem('X-Auth-Token', res['result']['token']);
            await localStorage.setItem('isLogin', true);
            emit(LoginSuccess());
          } else if (res['code'] == 422) {
            await localStorage.setItem('X-Auth-Token', null);
            await localStorage.setItem('isLogin', false);
            emit(LoginFailed(res['email'][0], res['password'][0]));
          } else if (res['code'] == 401) {
            await localStorage.setItem('X-Auth-Token', null);
            await localStorage.setItem('isLogin', false);
            emit(LoginUnauthorized());
          }
        }
      } catch (e) {
        print('login error => $e');
      }
    });

    on<RegisterHandle>((event, emit) async {
      RegisterRepository registerRepository = RegisterRepository();
      try {
        emit(AuthLoading());

        if (event.email!.isEmpty ||
            event.password!.isEmpty ||
            event.password!.length < 6) {
          String? emailMessage;
          String? passwordMessage;
          if (event.email!.isEmpty) {
            emailMessage = 'Email tidak boleh kosong';
          }
          if (event.password!.isEmpty) {
            passwordMessage = 'Password tidak boleh kosong';
          } else if (event.password!.length < 6) {
            passwordMessage = 'Password tidak boleh kurang dari 6 karakter';
          }

          emit(LoginFailed(emailMessage, passwordMessage));
        } else {
          Map<String, dynamic> req = {
            "email": event.email,
            "password": event.password
          };
          dynamic res = await registerRepository.register(req);
          int statusCode = res.statusCode;
          dynamic resData = res.data;
          if (statusCode == 201) {
            emit(LoginSuccess());
          } else if (statusCode == 422) {
            emit(LoginFailed(resData['email'][0], null));
          }
        }
      } catch (e, stackTrace) {
        print('register error => $e => $stackTrace');
      }
    });
  }
}
