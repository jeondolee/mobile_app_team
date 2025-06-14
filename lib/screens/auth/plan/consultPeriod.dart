import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/plan_info.dart';
import '../../../models/refData.dart';

class ConsultPeriodPage extends StatefulWidget {
  final PlanInfo planInfo;
  final RefData refData;

  const ConsultPeriodPage({
    super.key,
    required this.planInfo,
    required this.refData,});

  @override
  State<ConsultPeriodPage> createState() => _ConsultPeriodPageState();
}

class _ConsultPeriodPageState extends State<ConsultPeriodPage> {
  Set<int> _selectedIndexes = {};

  final List<String> _icons = ['🌲', '🌿', '🌱'];
  final List<String> _labels = ['긴소통', '적절한 소통', '짧은 소통'];
  final List<String> _times = ['6개월', '3개월', '1개월'];

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndexes = {index}; // 하나만 선택
    });
  }

  void _onNextPressed() {
    if (_selectedIndexes.isEmpty) return;

    final selectedText = _times[_selectedIndexes.first];
    final month = int.tryParse(selectedText.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    // 이 단계에서 고민 필요
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month + month, now.day);

    widget.planInfo.startDate = now;
    widget.planInfo.endDate = endDate;

    Navigator.of(context).pushNamed(
      '/planGuide',
      arguments: {
        'planInfo': widget.planInfo,
        'refData': widget.refData,
      },
    );
  }

  String getSelectedDurationText() {
    return _times[_selectedIndexes.first];
  }

  String getSelectedAmountText() {
    if (_selectedIndexes.isEmpty) return '';

    int totalIncome = widget.refData.totalFixedIncome;
    int rate = widget.planInfo.savingRate;
    final selectedMonthStr = _times[_selectedIndexes.first];
    final months = int.tryParse(selectedMonthStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    int savedAmount = (totalIncome * rate ~/ 100) * months;

    return '$savedAmount 원';
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final isSelected = _selectedIndexes.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 50,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const Text(
                '절약 기간을 선택해주세요',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: screenHeight * 0.2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return GestureDetector(
                    onTap: () => _onButtonPressed(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedIndexes.contains(index)
                                  ? Colors.black
                                  : Colors.white,
                              border: Border.all(
                                color: _selectedIndexes.contains(index)
                                    ? Colors.black
                                    : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Center(
                                child: Text(
                                  _icons[index],
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: _selectedIndexes.contains(index)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            _labels[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _selectedIndexes.contains(index)
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            _times[index],
                            style: TextStyle(
                              fontSize: 14,
                              color: _selectedIndexes.contains(index)
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Container(
                    width: 297,
                    height: 102,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEDF4FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Color(0xFF0062FF), width: 1.5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 31, top: 28, right: 15),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '김유저',
                                style: TextStyle(
                                  color: const Color(0xFF0062FF),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  letterSpacing: -1,
                                ),
                              ),
                              TextSpan(
                                text: '님은 ',
                                style: TextStyle(
                                  color: const Color(0xFF231F1F),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  letterSpacing: -1,
                                ),
                              ),
                              TextSpan(
                                text: getSelectedDurationText(),
                                style: TextStyle(
                                  color: const Color(0xFF0062FF),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  letterSpacing: -1,
                                ),
                              ),
                              TextSpan(
                                text: '동안\n',
                                style: TextStyle(
                                  color: const Color(0xFF231F1F),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  letterSpacing: -1,
                                ),
                              ),
                              TextSpan(
                                text: getSelectedAmountText(),
                                style: TextStyle(
                                  color: const Color(0xFF0062FF),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  letterSpacing: -1,
                                ),
                              ),
                              TextSpan(
                                text: '을 모으게 될 거에요',
                                style: TextStyle(
                                  color: const Color(0xFF231F1F),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
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
              SizedBox(height: screenHeight * 0.1),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isSelected ? _onNextPressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? const Color(0xFF007BFF)
                        : Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
