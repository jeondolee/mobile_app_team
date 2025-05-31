import 'package:flutter/material.dart';

class AdditionalChoice extends StatelessWidget {
  const AdditionalChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 설정
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 46.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              '변동이 생겼나요?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.5,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 80),

            // 첫 번째 선택 박스
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/deposit');
              },
              child: Container(
                width: double.infinity,
                height: 57,
                padding: const EdgeInsets.symmetric(horizontal: 29),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC7C7C7), width: 1),
                ),
                alignment: Alignment.centerLeft,
                child: const Text(
                  '추가 입금이 생겼어요',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 두 번째 선택 박스
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/spending');
              },
              child: Container(
                width: double.infinity,
                height: 57,
                padding: const EdgeInsets.symmetric(horizontal: 29),
                decoration: BoxDecoration(
                  // color: const Color(0xFFEDF4FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC7C7C7), width: 1),
                ),
                alignment: Alignment.centerLeft,
                child: const Text(
                  '추가 지출이 생겼어요',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
