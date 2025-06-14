import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../models/plan_info.dart';
import '../../../models/entry.dart';
import '../../../models/dateEntry.dart';

class DepositPeriodApplicationComplete extends StatelessWidget {
  final DateEntry dateEntry;
  final Future<PlanInfo?> _planInfoFuture;

  DepositPeriodApplicationComplete({
    super.key,
    required this.dateEntry,
  }) : _planInfoFuture = _loadPlanInfo();

  static Future<PlanInfo?> _loadPlanInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final planID = userDoc.data()?['planID'];
    if (planID == null) return null;

    final docPlanInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(planID)
        .get();

    if (docPlanInfo.exists && docPlanInfo.data() != null) {
      return PlanInfo.fromMap(docPlanInfo.data()!);
    }
    return null;
  }

  Future<void> _addToIncome() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final planID = userDoc.data()?['planID'];
    if (planID == null) return;

    final DateTime? date = dateEntry.date;
    if (date == null) return;

    final String searchDate = DateFormat('yyyy-MM-dd').format(date);

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('records')
        .doc(planID)
        .collection('income')
        .doc(searchDate);

    final docSnapshot = await docRef.get();

    List<Entry> existingEntries = [];
    if (docSnapshot.exists && docSnapshot.data() != null) {
      final existingData = DateEntry.fromMap(docSnapshot.data()!);
      existingEntries = existingData.dateEntry;
    }

    final int baseIdx = existingEntries.isEmpty
        ? 0
        : existingEntries.map((e) => e.idx).reduce((a, b) => a > b ? a : b) + 1;

    final List<Entry> newEntries = dateEntry.dateEntry.asMap().entries.map((entry) {
      return Entry(
        idx: baseIdx + entry.key,
        amount: entry.value.amount,
        category: entry.value.category,
        note: entry.value.note,
        type: entry.value.type,
      );
    }).toList();

    final allEntries = [...existingEntries, ...newEntries];

    final mergedEntry = DateEntry(
      date: date,
      dateEntry: allEntries,
    );

    await docRef.set(mergedEntry.toMap());
  }

  static Future<void> _uploadPlanInfo(PlanInfo planInfo) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final planID = userDoc.data()?['planID'];
    if (planID == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(planID)
        .set(planInfo.toMap());
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData localTheme = ThemeData(
      fontFamily: 'Pretendard',
      useMaterial3: true,
      primaryColor: const Color(0xFF2D64D8),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D64D8)),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF232020)),
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF232020),
          letterSpacing: -2,
        ),
      ),
    );

    return Theme(
      data: localTheme,
      child: FutureBuilder<PlanInfo?>(
        future: _planInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          }

          final planInfo = snapshot.data;
          if (planInfo == null) {
            return const Center(child: Text('플랜 정보를 불러올 수 없습니다.'));
          }

          final delayDays = (dateEntry.amount / planInfo.getDailyLimit(dateEntry.date!)).floor();
          planInfo.modEndDate = planInfo.effectiveEndDate?.subtract(Duration(days: delayDays));

          return Scaffold(
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
                      color: localTheme.primaryColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '${NumberFormat('#,###').format(dateEntry.amount)}원을\n기간에 반영했어요!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '추가 지출액으로\n목표금액 달성이 ${delayDays}일 앞당겨졌어요!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
                        await _addToIncome();
                        await _uploadPlanInfo(planInfo);
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: const Text(
                        '확인했어요',
                        style: TextStyle(
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
        },
      ),
    );
  }
}
