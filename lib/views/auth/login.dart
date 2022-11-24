import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupuk_frontend/blocs/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthBloc _authBloc = AuthBloc();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLogin = false;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.1),
            Image.asset('assets/images/splashscreen.jpg'),
            BlocProvider(
              create: (_) => _authBloc,
              child: _formLogin(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formLogin() {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginFailed) {
          _emailErrorMessage = state.email;
          _passwordErrorMessage = state.password;
        } else if (state is LoginUnauthorized) {
          _emailErrorMessage = null;
          _passwordErrorMessage = 'Email atau Password salah.';
        } else if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                TextFormField(
                  controller: _email,
                  cursorColor: Colors.orange,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(),
                    labelText: 'Email',
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    errorText: _emailErrorMessage,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _password,
                  cursorColor: Colors.orange,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    errorText: _passwordErrorMessage,
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    _authBloc.add(LoginHandle(_email.text, _password.text));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      (state is AuthLoading)
                          ? const Color.fromARGB(255, 241, 174, 85)
                          : const Color.fromARGB(255, 255, 153, 0),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2, horizontal: 100),
                    child: (state is AuthLoading)
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                RichText(
                  text: TextSpan(
                    text: 'Belum memiliki akun?',
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Daftar disini',
                        style:
                            const TextStyle(color: Colors.orange, fontSize: 18),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/register');
                          },
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
