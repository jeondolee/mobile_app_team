import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/VariableExpense_info.dart';

class AutoRegisterSummaryPage extends StatelessWidget {
  final List<ExpenseItem> selectedItems;

  const AutoRegisterSummaryPage({super.key, required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final dailyAmounts = selectedItems.map((item) {
      // 하루 소비 금액 계산 (30일로 나눔)
      final dailyAmount = (item.amount / 30).round();
      return ExpenseItem(category: item.category, amount: dailyAmount);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '자동 등록 신청사항은 다음과 같습니다.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: dailyAmounts.length,
                  itemBuilder: (context, index) {
                    final item = dailyAmounts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${item.category} 하루 ${formatter.format(item.amount)}원',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF0062FF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // 저장 또는 다음 페이지로 이동
                    Navigator.of(context).pushReplacementNamed('/selectAlarm');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0062FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('이렇게 플랜을 생성해 주세요'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('수정할래요'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
