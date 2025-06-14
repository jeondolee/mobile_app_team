import 'package:cloud_firestore/cloud_firestore.dart';

/* to map 사용 방식
await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .collection('plans')
    .doc('myPlan')
    .set(refDate.toMap());
 */

class PlanInfo {
  String planID;
  String planName;
  String planPurpose;
  int currentAmount; // +-의 누계를 구해야 함 + additional income
  int fixedIncomeAmount;
  int fixedConsumptionAmount;
  int additionalIncomeAmount;
  int additionalConsumptionAmount;
  int savingRate;
  //int dDay;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? modEndDate;
  DateTime createdAt;
  DateTime? now;

  PlanInfo({
    required this.planID,
    required this.planName,
    required this.planPurpose,
    this.currentAmount = 0,
    this.savingRate = 0,
    this.fixedIncomeAmount = 0,
    this.fixedConsumptionAmount = 0,
    this.additionalConsumptionAmount = 0,
    this.additionalIncomeAmount = 0,
    //this.dDay = 0,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? modEndDate,
    DateTime? createdAt,
    DateTime? now,
  })  : createdAt = createdAt ?? DateTime.now(),
        startDate = startDate,
        endDate = endDate,
        modEndDate = modEndDate,
        now = now ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'planID': planID,
      'planName': planName,
      'planPurpose': planPurpose,
      'currentAmount': currentAmount,
      'fixedIncomeAmount' : fixedIncomeAmount,
      'fixedConsumptionAmount' : fixedConsumptionAmount,
      'additionalIncomeAmount' : additionalIncomeAmount,
      'additionalConsumptionAmount' : additionalConsumptionAmount,
      'savingRate': savingRate,
      //'dDay': dDay,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'modEndDate': modEndDate != null ? Timestamp.fromDate(modEndDate!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PlanInfo.fromMap(Map<String, dynamic> map) {
    return PlanInfo(
      planID: map['planID'] ?? '',
      planName: map['planName'] ?? '',
      planPurpose: map['planPurpose'] ?? '',
      currentAmount: map['currentAmount'] ?? 0,
      fixedIncomeAmount: map['fixedIncomeAmount'] ?? 0,
      fixedConsumptionAmount: map['fixedConsumptionAmount'] ?? 0,
      additionalIncomeAmount: map['additionalIncomeAmount'] ?? 0,
      additionalConsumptionAmount: map['additionalConsumptionAmount'] ?? 0,
      savingRate: map['savingRate'] ?? 0,
      //dDay: map['dDay'] ?? 0,
      startDate: map['startDate'] != null
          ? (map['startDate'] as Timestamp).toDate().toLocal()
          : null,
      endDate: map['endDate'] != null
          ? (map['endDate'] as Timestamp).toDate().toLocal()
          : null,
      modEndDate: map['modEndDate'] != null
          ? (map['modEndDate'] as Timestamp).toDate().toLocal()
          : null,
      createdAt: (map['createdAt'] as Timestamp).toDate().toLocal(),
    );
  }

  int get planDurationInMonths {
    if (startDate == null || endDate == null) return 0;
    return (endDate!.year - startDate!.year) * 12 +
        (endDate!.month - startDate!.month);
  }

  int get monthlyLimit => ((fixedIncomeAmount * (100 - savingRate)) ~/ 100 - fixedConsumptionAmount);

  // if goalAmout를 직접 입력 받고 싶다면...?
  // 이건 추후에 생각하자...
  int get goalAmount {
    if (startDate == null || endDate == null) return 0;
    return ((fixedIncomeAmount * savingRate ~/ 100) * planDurationInMonths);
  }

  int get dDay {
    final referenceDate = modEndDate ?? endDate;
    if (referenceDate == null || now == null) return 0;
    return referenceDate.difference(now!).inDays;
  }

  DateTime? get effectiveEndDate {
    return modEndDate ?? endDate;
  }

  int getDailyLimit(DateTime date) {
    final firstDayThisMonth = DateTime(date.year, date.month, 1);
    final firstDayNextMonth = (date.month < 12)
        ? DateTime(date.year, date.month + 1, 1)
        : DateTime(date.year + 1, 1, 1);
    final daysInMonth = firstDayNextMonth.difference(firstDayThisMonth).inDays;

    return monthlyLimit ~/ daysInMonth;
  }
}

