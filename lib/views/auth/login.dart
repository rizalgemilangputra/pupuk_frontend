import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pupuk_frontend/repository/login_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isLogin = false;
  String errorMessage = '';

  _loginHandle() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      if (_isLogin == false) {
        setState(() {
          _isLogin = true;
        });
        LoginRepository loginRepository = LoginRepository();
        Map<String, dynamic> data = {
          "email": email.text,
          "password": password.text
        };
        loginRepository.login(data).then((value) {
          if (value == 200) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (value == 401) {
            setState(() {
              errorMessage = 'Email / Password salah';
            });
          } else {
            setState(() {
              errorMessage = 'Email / Password tidak boleh kosong.';
            });
          }
          _isLogin = false;
        });
      }
    }
  }

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
            _formLogin(),
          ],
        ),
      ),
    );
  }

  Widget _formLogin() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          TextFormField(
            controller: email,
            cursorColor: Colors.orange,
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
              labelText: 'Email',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: password,
            cursorColor: Colors.orange,
            obscureText: true,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.black),
              border: const OutlineInputBorder(),
              labelText: 'Password',
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
              errorText: errorMessage,
            ),
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () => _loginHandle(),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                (_isLogin)
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
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 100),
              child: (_isLogin)
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
                  style: const TextStyle(color: Colors.orange, fontSize: 18),
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
  }
}
