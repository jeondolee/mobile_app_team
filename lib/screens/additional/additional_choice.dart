import 'package:flutter/material.dart';
import '../../../models/dateEntry.dart';

class AdditionalChoice extends StatelessWidget {
  final DateEntry dateEntry;

  const AdditionalChoice({super.key, required this.dateEntry,});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'Pretendard',
        useMaterial3: true,
        primaryColor: const Color(0xFF2D64D8),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D64D8),
            primary: const Color(0xFF2D64D8)),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF232020)),
          titleTextStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF232020),
            letterSpacing: -2,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF4F4F4),
            foregroundColor: const Color(0xFF9D9D9D),
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size.fromHeight(50),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
            foregroundColor: const Color(0xFFB0B0B0),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, '/'),
          ),
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
                  Navigator.pushNamed(
                    context,
                    '/deposit',
                    arguments: dateEntry,
                  );
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
                  Navigator.pushNamed(
                    context,
                    '/spending',
                    arguments: dateEntry,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 57,
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  decoration: BoxDecoration(
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
      ),
    );
  }
}
