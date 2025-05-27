import 'package:flutter/material.dart';
import '../../../models/plan_info.dart';

class GetPlanNamePage extends StatefulWidget {
  const GetPlanNamePage({super.key});

  @override
  State<GetPlanNamePage> createState() => _GetPlanNamePageState();
}

class _GetPlanNamePageState extends State<GetPlanNamePage> {
  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _planPurposeController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _purposeFocus = FocusNode();

  String? _validateName(String text) {
    if (text.trim().isEmpty) {
      return '플랜 이름을 입력해주세요.';
    }
    return null;
  }

  String? _validatePurpose(String text) {
    if (text.trim().isEmpty) {
      return '플랜 목적을 입력해주세요.';
    }
    return null;
  }

  bool get _isFormValid =>
      _planNameController.text.trim().isNotEmpty &&
          _planPurposeController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _planNameController.dispose();
    _planPurposeController.dispose();
    _nameFocus.dispose();
    _purposeFocus.dispose();
    super.dispose();
  }

  Color _getBackgroundColor(String text) {
    return text.trim().isEmpty
        ? const Color(0xFFEDEDED)
        : const Color(0xFFEDF4FF);
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _isFormValid;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '플랜 개요를 설정해주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // 플랜 이름
            const Text('플랜 이름'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: _getBackgroundColor(_planNameController.text),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _planNameController,
                focusNode: _nameFocus,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'ex. 버킷리스트를 위한 다짐',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Builder(builder: (_) {
              final error = _validateName(_planNameController.text);
              if (_planNameController.text.isEmpty || error == null) {
                return const SizedBox.shrink();
              }
              return Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              );
            }),
            const SizedBox(height: 24),

            // 플랜 목적
            const Text('플랜 목적'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: _getBackgroundColor(_planPurposeController.text),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _planPurposeController,
                focusNode: _purposeFocus,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'ex. 여행을 위한 준비',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Builder(builder: (_) {
              final error = _validatePurpose(_planPurposeController.text);
              if (_planPurposeController.text.isEmpty || error == null) {
                return const SizedBox.shrink();
              }
              return Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              );
            }),

            const Spacer(),
            //
            // // 안내 문구
            // if (!isValid)
            //   const Text(
            //     '플랜 목적 입력 필수!\n아래 다음 버튼을 눌러주세요',
            //     style: TextStyle(color: Colors.grey, fontSize: 12),
            //   ),
            // const SizedBox(height: 8),

            // 다음 버튼
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isValid ? () {
                  final planInfo = PlanInfo(
                    planName: _planNameController.text.trim(),
                    planPurpose: _planPurposeController.text.trim(),
                  );
                  print('이메일: ${planInfo.planName}, pw: ${planInfo.planPurpose}');
                  Navigator.of(context).pushNamed(
                    '/getFixedIncome',
                    arguments: planInfo,
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isValid ? const Color(0xFF007BFF) : const Color(0xFFF2F2F2),
                  foregroundColor:
                  isValid ? Colors.white : const Color(0xFFAAAAAA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('다음'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
