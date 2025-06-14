import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../models/dateEntry.dart';
import '../../../models/entry.dart';
import '../../../models/plan_info.dart';
import '../../../models/refData.dart';

class DepositLimitApplicationComplete extends StatelessWidget {
  final DateEntry dateEntry;
  final Future<Map<String, dynamic>> _dataFuture;

  DepositLimitApplicationComplete({
    super.key,
    required this.dateEntry,
  }) : _dataFuture = _loadPlanInfoAndRefData();

  static Future<Map<String, dynamic>> _loadPlanInfoAndRefData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final planID = userDoc.data()?['planID'];
    if (planID == null) return {};

    final planSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(planID)
        .get();

    final refBase = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('records')
        .doc(planID)
        .collection('refData');

    final refSnaps = await Future.wait([
      refBase.doc('fixedIncomeData').get(),
      refBase.doc('fixedConsumptionData').get(),
      refBase.doc('variableConsumptionData').get(),
      refBase.doc('installmentConsumptionData').get(),
      refBase.doc('installmentIncomeData').get(),
    ]);

    final refData = RefData(
      planID: planID,
      fixedIncomes: refSnaps[0].exists ? RefData.fromFixedIncomesMap(refSnaps[0].data()!) : [],
      fixedConsumptions: refSnaps[1].exists ? RefData.fromFixedConsumptionsMap(refSnaps[1].data()!) : [],
      variableConsumptions: refSnaps[2].exists ? RefData.fromVariableConsumptionsMap(refSnaps[2].data()!) : [],
      installmentConsumptions: refSnaps[3].exists ? RefData.fromInstallmentConsumptionsMap(refSnaps[3].data()!) : [],
      installmentIncomes: refSnaps[4].exists ? RefData.fromInstallmentIncomesMap(refSnaps[4].data()!) : [],
    );

    return {
      'planInfo': planSnap.exists ? PlanInfo.fromMap(planSnap.data()!) : null,
      'refData': refData,
    };
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

  Future<void> _addToInstallmentIncome(RefData refData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final planID = userDoc.data()?['planID'];
    if (planID == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('records')
        .doc(planID)
        .collection('refData')
        .doc('installmentIncomeData');

    final docSnapshot = await docRef.get();

    List<Entry> existingEntries = [];
    if (docSnapshot.exists && docSnapshot.data() != null) {
      existingEntries = RefData.fromInstallmentConsumptionsMap(docSnapshot.data()!);
    }

    final int baseIdx = existingEntries.isEmpty
        ? 0
        : existingEntries.map((e) => e.idx).reduce((a, b) => a > b ? a : b) + 1;

    final List<Entry> newEntries = refData.installmentConsumptions.asMap().entries.map((entry) {
      return Entry(
        idx: baseIdx + entry.key,
        amount: entry.value.amount,
        category: entry.value.category,
        note: entry.value.note,
        type: entry.value.type,
        dateTime: entry.value.dateTime,
      );
    }).toList();

    final allEntries = [...existingEntries, ...newEntries];

    final mergedMap = {
      'installmentIncome': allEntries.map((e) => e.toMap()).toList(),
    };

    await docRef.set(mergedMap);
  }

  @override
  Widget build(BuildContext context) {
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
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF232020),
          letterSpacing: -2,
        ),
      ),
    );

    return Theme(
      data: localTheme,
      child: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("오류 발생: ${snapshot.error}"));
          }

          final planInfo = snapshot.data?['planInfo'] as PlanInfo?;
          final refData = snapshot.data?['refData'] as RefData?;

          if (planInfo == null || refData == null) {
            return const Center(child: Text("플랜 정보를 불러올 수 없습니다."));
          }

          dateEntry.fillDateToEntries();
          // 이거 타이밍..

          final duration = planInfo.effectiveEndDate!.difference(dateEntry.date!);
          final days = duration.inDays;

          int oldDailyLimit = planInfo.getDailyLimit(dateEntry.date!) -
              refData.getInstallmentConsumptionAmount(dateEntry.date!, planInfo.effectiveEndDate!) +
              refData.getInstallmentIncomeAmount(dateEntry.date!, planInfo.effectiveEndDate!);

          int newDailyLimit = oldDailyLimit + (dateEntry.amount / days).round();

          refData.installmentIncomes = dateEntry.dateEntry;

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
                      color: localTheme.primaryColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '${NumberFormat('#,###').format(dateEntry.amount)}원을\n소비한도에 반영했어요!',
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
                    '기존 플랜의 하루 소비한도가\n${NumberFormat('#,###').format(oldDailyLimit)}원에서 ${NumberFormat('#,###').format(newDailyLimit)}원으로 변경되었어요',
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
                        await _addToInstallmentIncome(refData);
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
