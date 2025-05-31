import 'package:flutter/material.dart';
import 'package:sotong/screens/auth/plan/planGuide.dart';
import 'consultPeriod.dart';

class ConsultRatioPage extends StatefulWidget {
  const ConsultRatioPage({super.key});

  @override
  State<ConsultRatioPage> createState() => _ConsultRatioPageState();
}

class _ConsultRatioPageState extends State<ConsultRatioPage> {
  int selectedIndex = -1;

  String getSavingAmount() {
    switch (selectedIndex) {
      case 0:
        return '500,000 원 절약!';
      case 1:
        return '300,000 원 절약!';
      case 2:
        return '100,000 원 절약!';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              '절약 비율을 선택해주세요',
              style: TextStyle(
                color: Color(0xFF231E1E),
                fontSize: 28,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w800,
                letterSpacing: -2,
              ),
            ),
            SizedBox(height: 80),
            Stack(
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(3, (index) {
                      double offsetX = 0;
                      if (selectedIndex == index) {
                        if (index == 0) {
                          offsetX = 15;
                        } else if (index == 2) {
                          offsetX = -15;
                        }
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Container(
                              height: 48,
                              margin: EdgeInsets.only(bottom: 8),
                              child: selectedIndex == index
                                  ? Transform.translate(
                                offset: Offset(offsetX, 0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF231F1F),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    getSavingAmount(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'Pretendard Variable',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                              )
                                  : SizedBox.shrink(),
                            ),
                            _buildOption(
                              index,
                              ['강력하게', '적절하게', '부담없이'][index],
                              ['75%', '50%', '25%'][index],
                              [
                                // 'assets/images/75_n.png',
                                // 'assets/images/50_n.png',
                                // 'assets/images/25_n.png'
                              ][index],
                              72,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0, bottom: 16),
                child: Text(
                  '강력하게! 눌러주세요',
                  style: TextStyle(
                    color: Color(0xFF9D9D9D),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (selectedIndex != -1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConsultPeriodPage()),
                  );
                }
              },
              child: Container(
                width: 294,
                height: 50,
                decoration: ShapeDecoration(
                  color: selectedIndex != -1 ? Colors.blue : Color(0xFFF4F4F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '다음',
                  style: TextStyle(
                    color: selectedIndex != -1 ? Colors.white : Color(0xFF9D9D9D),
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

  Widget _buildOption(int index, String label, String percentage, String imageUrl, [double size = 84]) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              border: Border.all(
                color: Color(0xFFC7C7C7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(size / 2),
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
            percentage,
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
