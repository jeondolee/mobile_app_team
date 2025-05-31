import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sotong/screens/additional/deposit/deposit.dart';

class PeriodApplicationComplete extends StatelessWidget {
  final List<DepositItem> depositItems;

  const PeriodApplicationComplete({
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

      final batch = FirebaseFirestore.instance.batch();
      final planRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('plans')
          .doc('main');

      final depositRef = planRef.collection('additionalDeposits');
      int totalDepositAmount = 0;

      for (var item in depositItems) {
        final newDoc = depositRef.doc();
        batch.set(newDoc, item.toJson());
        totalDepositAmount += item.amount;
      }

      batch.update(planRef, {
        'currentSavedAmount': FieldValue.increment(totalDepositAmount),
      });

      await batch.commit();
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
                Icons.calendar_today,
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '1,500,000원을\n기간에 반영했어요!',
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
              '추가 입금액으로\n목표금액 달성이 27일 앞당겨졌어요!',
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