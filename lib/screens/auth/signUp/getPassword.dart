import 'package:flutter/material.dart';
import '../../../models/sign_up_info.dart';

class GetPasswordPage extends StatefulWidget {
  final SignUpInfo signUpInfo;

  const GetPasswordPage({Key? key, required this.signUpInfo}) : super(key: key);

  @override
  _GetPasswordPageState createState() => _GetPasswordPageState();
}

class _GetPasswordPageState extends State<GetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isValidPassword = false;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    if (value.length < 6) {
      return '비밀번호는 6자리 이상이어야 합니다';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      final isValid = _validatePassword(_passwordController.text) == null;
      setState(() {
        _isValidPassword = isValid;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final signUpInfo = widget.signUpInfo;

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
                      '비밀번호를 입력하세요',
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
                              color: _passwordController.text.isEmpty
                                  ? const Color(0xFFEDEDED)
                                  : const Color(0xFFEDF4FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              controller: _passwordController,
                              focusNode: _focusNode,
                              obscureText: true,
                              validator: _validatePassword,
                              decoration: const InputDecoration(
                                hintText: '비밀번호를 입력하세요',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Builder(
                            builder: (_) {
                              final errorText =
                              _validatePassword(_passwordController.text);
                              if (_passwordController.text.isEmpty || errorText == null) {
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
                child: ElevatedButton(
                  onPressed: _isValidPassword
                      ? () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      final updatedInfo = SignUpInfo(
                        email: signUpInfo.email,
                        password: _passwordController.text.trim(),
                      );
                      Navigator.of(context).pushNamed(
                        '/getUserInfo',
                        arguments: updatedInfo,
                      );
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isValidPassword
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