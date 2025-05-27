import 'package:cloud_firestore/cloud_firestore.dart';

class PlanInfo {
  String planName;
  String planPurpose;
  DateTime createdAt;
  List<Map<String, dynamic>> fixedIncomes;

  PlanInfo({
    required this.planName,
    required this.planPurpose,
    DateTime? createdAt,
    List<Map<String, dynamic>>? fixedIncomes,
  })  : createdAt = createdAt ?? DateTime.now(),
        fixedIncomes = fixedIncomes ?? [];

  Map<String, dynamic> toMap() {
    return {
      'planName': planName,
      'planPurpose': planPurpose,
      'createdAt': createdAt,
      'fixedIncomes': fixedIncomes,
    };
  }

  factory PlanInfo.fromMap(Map<String, dynamic> map) {
    return PlanInfo(
      planName: map['planName'] ?? '',
      planPurpose: map['planPurpose'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      fixedIncomes: List<Map<String, dynamic>>.from(map['fixedIncomes'] ?? []),
    );
  }
}
