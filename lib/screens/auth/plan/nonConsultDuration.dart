import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'planGuide.dart';

class NonConsultDurationPage extends StatefulWidget {
  const NonConsultDurationPage({Key? key}) : super(key: key);

  @override
  State<NonConsultDurationPage> createState() => _NonConsultDurationPageState();
}

class _NonConsultDurationPageState extends State<NonConsultDurationPage> {
  final TextEditingController _startMonthController = TextEditingController(text: '3');
  final TextEditingController _startDayController = TextEditingController(text: '11');
  final TextEditingController _endMonthController = TextEditingController(text: '4');
  final TextEditingController _endDayController = TextEditingController(text: '11');

  @override
  void dispose() {
    _startMonthController.dispose();
    _startDayController.dispose();
    _endMonthController.dispose();
    _endDayController.dispose();
    super.dispose();
  }

  bool isDefaultValue() {
    return _startMonthController.text == '3' &&
        _startDayController.text == '11' &&
        _endMonthController.text == '4' &&
        _endDayController.text == '11';
  }

  bool get _isAllDateFilled {
    return _startMonthController.text.isNotEmpty &&
        _startDayController.text.isNotEmpty &&
        _endMonthController.text.isNotEmpty &&
        _endDayController.text.isNotEmpty;
  }

  int get _monthDifference {
    int startMonth = int.tryParse(_startMonthController.text) ?? 3;
    int endMonth = int.tryParse(_endMonthController.text) ?? 4;
    int diff = endMonth - startMonth;
    if (diff < 0) diff = 0;
    return diff;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.only(left: 36),
                          child: Text(
                            '달성 기간을 설정해주세요',
                            style: TextStyle(
                              color: Color(0xFF231E1E),
                              fontSize: 32,
                              fontFamily: 'Pretendard Variable',
                              fontWeight: FontWeight.w800,
                              letterSpacing: -2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(left: 36),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _editableValueLabelBox(_startMonthController, '월'),
                              const SizedBox(width: 12),
                              _editableValueLabelBox(_startDayController, '일부터'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 36),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _editableValueLabelBox(_endMonthController, '월'),
                              const SizedBox(width: 12),
                              _editableValueLabelBox(_endDayController, '일까지'),
                            ],
                          ),
                        ),
                        if (!isDefaultValue()) ...[
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 36),
                            child: Container(
                              width: 297,
                              height: 102,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF4FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(31, 28, 0, 0),
                                child: SizedBox(
                                  width: 243,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '김유저',
                                          style: const TextStyle(
                                            color: Color(0xFF0062FF),
                                            fontSize: 17,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                            height: 1.40,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '님은 ',
                                          style: const TextStyle(
                                            color: Color(0xFF231F1F),
                                            fontSize: 17,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                            height: 1.40,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '$_monthDifference개월',
                                          style: const TextStyle(
                                            color: Color(0xFF0062FF),
                                            fontSize: 17,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                            height: 1.40,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '동안\n월 ',
                                          style: TextStyle(
                                            color: Color(0xFF231F1F),
                                            fontSize: 17,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                            height: 1.40,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '000,000 원',
                                          style: TextStyle(
                                            color: Color(0xFF0062FF),
                                            fontSize: 17,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                            height: 1.40,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '을 모으게 될 거에요',
                                          style: TextStyle(
                                            color: Color(0xFF231F1F),
                                            fontSize: 17,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                            height: 1.40,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Visibility(
                          visible: !(isDefaultValue() || _isAllDateFilled),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 36),
                            child: Text(
                              '조금만 기다려주세요',
                              style: TextStyle(
                                color: Color(0xFF231F1F),
                                fontSize: 18,
                                fontFamily: 'Noto Sans',
                                fontWeight: FontWeight.w400,
                                letterSpacing: -1,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child: TextButton(
                            onPressed: () {
                              print('Button pressed');
                              Navigator.pushNamed(context, '/planGuide');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: isDefaultValue() ? const Color(0xFFF4F4F4) : const Color(0xFF0062FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Text(
                              '다음',
                              style: TextStyle(
                                color: isDefaultValue() ? const Color(0xFF9D9D9D) : Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 134,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _editableValueLabelBox(TextEditingController controller, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEDF4FF),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLines: 1,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              counterText: '',
            ),
            maxLength: 2,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (_) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF231F1F),
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }
}
