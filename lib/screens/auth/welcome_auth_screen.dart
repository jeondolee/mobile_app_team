import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 90,
            left: 46,
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                children: [
                  TextSpan(text: '재미있게 ', style: TextStyle(color: Color(0xFF231F1F))),
                  TextSpan(text: '소통', style: TextStyle(color: Color(0xFF0062FF))),
                  TextSpan(text: '하며\n', style: TextStyle(color: Color(0xFF231F1F))),
                  TextSpan(text: '소비 통제', style: TextStyle(color: Color(0xFF0062FF))),
                  TextSpan(text: ' 하자!', style: TextStyle(color: Color(0xFF231F1F))),
                ],
              ),
            ),
          ),
          Positioned(
            top: 487,
            left: 46,
            right: 46,
            child: _buildLoginButton(
              color: const Color(0xFFFEE500),
              text: '카카오로 시작하기',
              onTap: () {},
            ),
          ),
          Positioned(
            top: 552,
            left: 46,
            right: 46,
            child: _buildLoginButton(
              color: Colors.black,
              text: 'Apple로 로그인',
              textColor: Colors.white,
              onTap: () {},
            ),
          ),
          Positioned(
            top: 617,
            left: 46,
            right: 46,
            child: _buildLoginButton(
              color: Colors.white,
              text: 'Google로 계속하기',
              border: true,
              onTap: () {},
            ),
          ),
          Positioned(
            top: 712,
            left: 145,
            child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/getEmail'),
              child: const Text(
                '이메일로 계속하기',
                style: TextStyle(
                  color: Color(0xFF9A9A9A),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
          Positioned(
            top: 742,
            left: 140,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushReplacementNamed('/email_login'),
              child: const Text(
                '기존 계정으로 로그인',
                style: TextStyle(
                  color: Color(0xFF9A9A9A),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton({
    required Color color,
    required String text,
    required VoidCallback onTap,
    Color textColor = const Color(0xFF191919),
    bool border = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: border ? Border.all(color: const Color(0xFFC5C5C5)) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
          ),
        ),
      ),
    );
  }
}