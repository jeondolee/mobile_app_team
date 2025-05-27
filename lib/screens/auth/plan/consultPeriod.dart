import 'package:flutter/material.dart';
import 'package:sotong/screens/auth/plan/planGuide.dart';

class ConsultPeriodPage extends StatefulWidget {
  const ConsultPeriodPage({super.key});

  @override
  State<ConsultPeriodPage> createState() => _ConsultPeriodPageState();
}

class _ConsultPeriodPageState extends State<ConsultPeriodPage> {
  int selectedPeriodIndex = -1;

  String getSelectedDurationText() {
    switch (selectedPeriodIndex) {
      case 0:
        return '6개월';
      case 1:
        return '3개월';
      case 2:
        return '1개월';
      default:
        return '';
    }
  }

  String getSelectedAmountText() {
    switch (selectedPeriodIndex) {
      case 0:
        return '600,000 원';
      case 1:
        return '300,000 원';
      case 2:
        return '100,000 원';
      default:
        return '0 원';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedPeriodIndex != -1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              '기간을 선택해주세요',
              style: TextStyle(
                color: Color(0xFF231E1E),
                fontSize: 28,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w800,
                letterSpacing: -2,
              ),
            ),
            SizedBox(height: 32),
            if (isSelected)
              Container(
                width: 210,
                height: 44,
                padding: const EdgeInsets.only(left: 18, right: 10),
                decoration: ShapeDecoration(
                  color: const Color(0xFF231F1F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    side: BorderSide(color: Colors.white, width: 1.5),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  '${getSelectedDurationText()} 동안 화이팅 해 봐요!',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOption(0, '긴 소통', '6개월', 'assets/images/6_n.png'),
                SizedBox(width: 24),
                _buildOption(1, '적절한 소통', '3개월', 'assets/images/3_n.png'),
                SizedBox(width: 24),
                _buildOption(2, '짧은 소통', '1개월', 'assets/images/1_n.png'),
              ],
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
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.40,
                                letterSpacing: -1,
                              ),
                            ),
                            TextSpan(
                              text: '님은 ',
                              style: TextStyle(
                                color: const Color(0xFF231F1F),
                                fontSize: 17,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.40,
                                letterSpacing: -1,
                              ),
                            ),
                            TextSpan(
                              text: getSelectedDurationText(),
                              style: TextStyle(
                                color: const Color(0xFF0062FF),
                                fontSize: 17,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.40,
                                letterSpacing: -1,
                              ),
                            ),
                            TextSpan(
                              text: '동안\n',
                              style: TextStyle(
                                color: const Color(0xFF231F1F),
                                fontSize: 17,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.40,
                                letterSpacing: -1,
                              ),
                            ),
                            TextSpan(
                              text: getSelectedAmountText(),
                              style: TextStyle(
                                color: const Color(0xFF0062FF),
                                fontSize: 17,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.40,
                                letterSpacing: -1,
                              ),
                            ),
                            TextSpan(
                              text: '을 모으게 될 거에요',
                              style: TextStyle(
                                color: const Color(0xFF231F1F),
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
            Spacer(),
            GestureDetector(
              onTap: isSelected
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanGuidePage(),
                  ),
                );
              }
                  : null,
              child: Container(
                width: 294,
                height: 50,
                decoration: ShapeDecoration(
                  color: isSelected ? Color(0xFF2F80ED) : Color(0xFFF4F4F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '다음',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Color(0xFF9D9D9D),
                    fontSize: 17,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int index, String label, String duration, String imageUrl) {
    bool isSelected = selectedPeriodIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriodIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              border: Border.all(
                color: Color(0xFFC7C7C7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(42),
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(imageUrl),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF231F1F),
              fontSize: 17,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          Text(
            duration,
            style: TextStyle(
              color: Color(0xFF231F1F),
              fontSize: 14,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w600,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }
}
