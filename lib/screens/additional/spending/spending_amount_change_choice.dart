import 'package:flutter/material.dart';
import '../../../models/dateEntry.dart';

class SpendingAmountChangeChoice extends StatefulWidget {
  final DateEntry dateEntry;

  const SpendingAmountChangeChoice({
    super.key,
    required this.dateEntry,
  });

  @override
  State<SpendingAmountChangeChoice> createState() => _SpendingAmountChangeChoiceState();
}

class _SpendingAmountChangeChoiceState extends State<SpendingAmountChangeChoice> {
  bool isGoalSelected = false;
  bool isLimitSelected = false;

  void _navigateToNextScreen() {
    if (isGoalSelected) {
      Navigator.pushNamed(
        context,
        '/spending_period_application_complete',
        arguments: widget.dateEntry,
      );
    } else if (isLimitSelected) {
      Navigator.pushNamed(
        context,
        '/spending_limit_application_complete',
        arguments: widget.dateEntry,
      );
    }
  }

  final ThemeData localTheme = ThemeData(
    fontFamily: 'Pretendard',
    useMaterial3: true,
    primaryColor: const Color(0xFF2D64D8),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2D64D8),
      primary: const Color(0xFF2D64D8),
    ),
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
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF4F4F4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: Color(0xFF909090),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
            if (states.contains(MaterialState.disabled)) {
              return const Color(0xFFF4F4F4);
            }
            return const Color(0xFF2D64D8);
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
            if (states.contains(MaterialState.disabled)) {
              return const Color(0xFF9E9E9E);
            }
            return Colors.white;
          },
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(50)),
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
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: localTheme,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('추가 지출'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 46.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '금액에 변화가 생겼어요.\n',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '소비 한도',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0062FF),
                      ),
                    ),
                    TextSpan(
                      text: '나 ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '목표 달성 기간',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0062FF),
                      ),
                    ),
                    TextSpan(
                      text: '을\n변경하시겠어요?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildOptionButton(
                title: '기간을 변경할래요',
                isSelected: isGoalSelected,
                onTap: () {
                  setState(() {
                    isGoalSelected = true;
                    isLimitSelected = false;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildOptionButton(
                title: '소비 한도를 변경할래요',
                isSelected: isLimitSelected,
                onTap: () {
                  setState(() {
                    isGoalSelected = false;
                    isLimitSelected = true;
                  });
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: (isGoalSelected || isLimitSelected) ? _navigateToNextScreen : null,
                  child: const Text('다음'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF0062FF) : const Color(0xFFD9D9D9),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0062FF) : Colors.black54,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
