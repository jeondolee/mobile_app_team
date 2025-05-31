import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sotong/screens/additional/deposit/deposit.dart';

class LimitApplicationComplete extends StatelessWidget {
  final List<DepositItem> depositItems;

  const LimitApplicationComplete({
    super.key,
    required this.depositItems,
  });

  Future<void> _uploadToFirebase(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인이 필요합니다.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // 현재 활성화된 planId를 가져오기 위한 참조
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDoc = await userRef.get();
      final String activePlanId = userDoc.data()?['activePlanId'] ?? 'main';

      // additionalIncome 문서 참조
      final additionalIncomeRef = userRef
          .collection('records')
          .doc(activePlanId)
          .collection('refData')
          .doc('additionalIncome');

      // earnings 맵 생성 및 total 계산
      Map<String, Map<String, dynamic>> earnings = {};
      int total = 0;

      for (int i = 0; i < depositItems.length; i++) {
        final item = depositItems[i];
        earnings[(i + 1).toString()] = {
          'amount': item.amount,
          'note': item.note,
          'category': item.category,
          'autoReg': false,
          'time': item.date,
          'type': '추가'
        };
        total += item.amount;
      }

      // Firestore에 데이터 저장
      await additionalIncomeRef.set({
        'total': total,
        'earnings': earnings,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('입금 내역이 성공적으로 저장되었습니다.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('저장 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 46.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 250),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '1,500,000원을\n소비한도에 반영했어요!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.3,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '기존 플랜의 하루 소비한도가\n7,000원에서 8,500원으로 변경되었어요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF909090),
                height: 1.3,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  await _uploadToFirebase(context);
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '확인했어요',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
} 