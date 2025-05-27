import 'package:flutter/material.dart';

import '../../../models/sign_up_info.dart';

class GetEmailPage extends StatefulWidget {
  const GetEmailPage({Key? key}) : super(key: key);

  @override
  _GetEmailPageState createState() => _GetEmailPageState();
}

class _GetEmailPageState extends State<GetEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isValidEmail = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return '올바른 이메일 형식을 입력해주세요';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      final isValid =
      RegExp(r'\S+@\S+\.\S+').hasMatch(_emailController.text.trim());
      setState(() {
        _isValidEmail = isValid;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      '이메일을 입력하세요',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: _emailController.text.isEmpty
                                  ? const Color(0xFFEDEDED)
                                  : const Color(0xFFEDF4FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              controller: _emailController,
                              focusNode: _focusNode,
                              validator: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'ex. sotong@google.com',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Builder(
                            builder: (_) {
                              final errorText =
                              _validateEmail(_emailController.text);
                              if (_emailController.text.isEmpty ||
                                  errorText == null) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                errorText,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 200),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child:
                  ElevatedButton(
                    onPressed: _isValidEmail
                        ? () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        final email = _emailController.text.trim();
                        final signUpInfo = SignUpInfo(email: email, password: '');
                        print('이메일: ${signUpInfo.email}, pw: ${signUpInfo.password}');
                        Navigator.of(context).pushNamed(
                          '/getPassword',
                          arguments: SignUpInfo(email: _emailController.text, password: ''),
                        );
                      }
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isValidEmail
                          ? const Color(0xFF0062FF)
                          : Colors.grey[300],
                      disabledBackgroundColor: Colors.grey[300],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}