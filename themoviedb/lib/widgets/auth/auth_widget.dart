import 'package:flutter/material.dart';
import 'package:themoviedb/Theme/button_style.dart';
import 'package:themoviedb/widgets/main_screen/main_screen_widget.dart';

//main
class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login to your account',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _HeaderWidget(),
    );
  }
}

//head
class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(fontSize: 16, color: Colors.black);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              _FormWidget(),
              SizedBox(height: 25),
              Text(
                'To use TMDB\'s editing and voting features, as well as receive personalized recommendations, you need to log in to your account. If you don\'t have a TMDB account yet, you can easily register for free. Click here to get started.',
                style: textStyle,
              ),
              SizedBox(height: 5),
              TextButton(
                onPressed: () {},
                child: Text('Register'),
                style: AppButtonStyle.linkButton,
              ),
              SizedBox(height: 25),
              Text(
                'If you have registered but have not received a confirmation email, click here to get another confirmation email.',
                style: textStyle,
              ),
              SizedBox(height: 5),
              TextButton(
                onPressed: () {},
                child: Text('Veify email'),
                style: AppButtonStyle.linkButton,
              ),
              SizedBox(height: 25),
            ],
          ),
        ],
      ),
    );
  }
}

//forms
class _FormWidget extends StatefulWidget {
  const _FormWidget({super.key});

  @override
  State<_FormWidget> createState() => __FormWidgetState();
}

class __FormWidgetState extends State<_FormWidget> {
  final textStyle = const TextStyle(fontSize: 16, color: Color(0xFF212529));
  final textFielDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    isCollapsed: true,
  );

  final color = const Color(0xFF01B4E4);

  final buttonStyleFirst = TextButton.styleFrom(
    backgroundColor: Color(0xFF01B4E4),
    foregroundColor: Colors.white,
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
  );
  //потом это убрать, это для экономии времени
  final _loginController = TextEditingController(text: 'a');
  final _passsworController = TextEditingController(text: 'a');
  String? errorText = null;

  void _auth() {
    final login = _loginController.text;
    final password = _passsworController.text;

    if (login == 'a' && password == 'a') {
      errorText = null;

      Navigator.of(context).pushReplacementNamed('/main_screen');
      //Navigator.of(context).pushNamed('/main_screen');
    } else {
      errorText = 'Не верный логин или пароль';
      print('show error');
    }
    setState(() {});
  }

  void _resetPassword() {
    print('reset Password');
  }

  @override
  Widget build(BuildContext context) {
    final errorText = this.errorText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorText != null) ...[
          Text(errorText, style: TextStyle(color: Colors.red, fontSize: 17)),
          SizedBox(height: 25),
        ],

        Text('Username', style: textStyle),
        TextField(decoration: textFielDecoration, controller: _loginController),
        Text('Password', style: textStyle),
        TextField(
          decoration: textFielDecoration,
          obscureText: true,
          controller: _passsworController,
        ),
        Row(
          children: [
            TextButton(
              style: buttonStyleFirst,
              onPressed: _auth,
              child: Text('Login'),
            ),
            SizedBox(width: 30),
            TextButton(
              onPressed: _resetPassword,
              child: Text('Reset password'),
              style: AppButtonStyle.linkButton,
            ),
          ],
        ),
      ],
    );
  }
}
