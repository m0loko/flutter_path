import 'package:flutter/material.dart';
import 'package:themoviedb/Theme/button_style.dart';
import 'package:themoviedb/library/Widgets/Inherited/provider.dart';
import 'package:themoviedb/widgets/auth/auth_model.dart';
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
        physics: const BouncingScrollPhysics(),
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

class _FormWidget extends StatelessWidget {
  _FormWidget({super.key});
  /////////////////////////////////////////////////////////////////////////
  //цвета и тд (рефакт)
  final textStyle = const TextStyle(fontSize: 16, color: Color(0xFF212529));
  final textFielDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    isCollapsed: true,
  );
  final color = const Color(0xFF01B4E4);
  static final buttonStyleFirst = TextButton.styleFrom(
    backgroundColor: Color(0xFF01B4E4),
    foregroundColor: Colors.white,
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
  );
  /////////////////////////////////////////////////////////////////////////
  ///
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<AuthModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ErrorMessageWidget(),
        Text('Username', style: textStyle),
        TextField(
          decoration: textFielDecoration,
          controller: model?.loginController,
        ),
        Text('Password', style: textStyle),
        TextField(
          decoration: textFielDecoration,
          obscureText: true,
          controller: model?.passsworController,
        ),
        Row(
          children: [
            const _AuthBottonWidget(),
            SizedBox(width: 30),
            TextButton(
              onPressed: () {},
              child: const Text('Reset password'),
              style: AppButtonStyle.linkButton,
            ),
          ],
        ),
      ],
    );
  }
}

class _AuthBottonWidget extends StatelessWidget {
  const _AuthBottonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<AuthModel>(context);
    final onPressed = model?.canStartAuth == true
        ? () => model?.auth(context)
        : null;
    final child = model?.isAuthProgress == true
        ? const SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2),
            width: 15,
            height: 15,
          )
        : const Text('Login');
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFF01B4E4),
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final errorMessage = NotifierProvider.watch<AuthModel>(
      context,
    )?.errorMessage;
    if (errorMessage == null) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 17),
      ),
    );
  }
}
