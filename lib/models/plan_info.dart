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
  int goalAmount;
  int currentAmount;
  int savingRate;
  int dDay;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? modEndDate;
  DateTime createdAt;

  PlanInfo({
    required this.planID,
    required this.planName,
    required this.planPurpose,
    this.goalAmount = 0,
    this.currentAmount = 0,
    this.savingRate = 0,
    this.dDay = 0,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? modEndDate,
    DateTime? createdAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        startDate = startDate,
        endDate = endDate,
        modEndDate = modEndDate;

  Map<String, dynamic> toMap() {
    return {
      'planID': planID,
      'planName': planName,
      'planPurpose': planPurpose,
      'goalAmount': goalAmount,
      'currentAmount': currentAmount,
      'savingRate': savingRate,
      'dDay': dDay,
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
      goalAmount: map['goalAmount'] ?? 0,
      currentAmount: map['currentAmount'] ?? 0,
      savingRate: map['savingRate'] ?? 0,
      dDay: map['dDay'] ?? 0,
      startDate: map['startDate'] != null
          ? (map['startDate'] as Timestamp).toDate()
          : null,
      endDate: map['endDate'] != null
          ? (map['endDate'] as Timestamp).toDate()
          : null,
      modEndDate: map['modEndDate'] != null
          ? (map['modEndDate'] as Timestamp).toDate()
          : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}

