import 'package:cloud_firestore/cloud_firestore.dart';
import 'entry.dart';

class RefData {
  String planID;
  List<Entry> fixedIncomes;
  List<Entry> fixedConsumptions;
  List<Entry> variableConsumptions;
  List<Entry> installmentIncomes;         // 할부 수입
  List<Entry> installmentConsumptions;         // 할부 소비
  List<Entry> additionalIncomeList;            // 추가 수입
  List<Entry> additionalConsumptionList;       // 추가 소비
  List<Entry> variableConsumptionList;         // 변동 소비 상세 리스트

  RefData({
    this.planID = '',
    this.fixedIncomes = const [],
    this.fixedConsumptions = const [],
    this.variableConsumptions = const [],
    this.installmentIncomes = const [],
    this.installmentConsumptions = const [],
    this.additionalIncomeList = const [],
    this.additionalConsumptionList = const [],
    this.variableConsumptionList = const [],
  });

  // toMap 메서드
  Map<String, dynamic> fixedIncomesToMap() => {
    'fixedIncomes': fixedIncomes.map((e) => e.toMap()).toList(),
  };

  Map<String, dynamic> fixedConsumptionsToMap() => {
    'fixedConsumptions': fixedConsumptions.map((e) => e.toMap()).toList(),
  };

  Map<String, dynamic> variableConsumptionsToMap() => {
    'variableConsumptions': variableConsumptions.map((e) => e.toMap()).toList(),
  };

  Map<String, dynamic> installmentIncomesToMap() => {
    'installmentIncomes': installmentIncomes.map((e) => e.toMap()).toList(),
  };

  Map<String, dynamic> installmentConsumptionsToMap() => {
    'installmentConsumptions': installmentConsumptions.map((e) => e.toMap()).toList(),
  };

  Map<String, dynamic> additionalIncomeListToMap() => {
    'additionalIncomeList': additionalIncomeList.map((e) => e.toMap()).toList(),
  };

  Map<String, dynamic> additionalConsumptionListToMap() => {
    'additionalConsumptionList': additionalConsumptionList.map((e) => e.toMap()).toList(),
  };

  Map<String, dynamic> variableConsumptionListToMap() => {
    'variableConsumptionList': variableConsumptionList.map((e) => e.toMap()).toList(),
  };


  // fromMap 메서드
  static List<Entry> fromFixedIncomesMap(Map<String, dynamic> map) {
    return (map['fixedIncomes'] as List<dynamic>?)
        ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
        .toList() ??
        [];
  }

  static List<Entry> fromFixedConsumptionsMap(Map<String, dynamic> map) {
    return (map['fixedConsumptions'] as List<dynamic>?)
        ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
        .toList() ??
        [];
  }

  static List<Entry> fromVariableConsumptionsMap(Map<String, dynamic> map) {
    return (map['variableConsumptions'] as List<dynamic>?)
        ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
        .toList() ??
        [];
  }

  static List<Entry> fromInstallmentIncomesMap(Map<String, dynamic> map) {
    return (map['installmentIncomes'] as List<dynamic>?)
        ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
        .toList() ?? [];
  }

  static List<Entry> fromInstallmentConsumptionsMap(Map<String, dynamic> map) {
    return (map['installmentConsumptions'] as List<dynamic>?)
        ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
        .toList() ??
        [];
  }

  static List<Entry> fromAdditionalIncomeListMap(Map<String, dynamic> map) {
    return (map['additionalIncomeList'] as List<dynamic>?)
        ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
        .toList() ??
        [];
  }

  static List<Entry> fromAdditionalConsumptionListMap(Map<String, dynamic> map) {
    return (map['additionalConsumptionList'] as List<dynamic>?)
        ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
        .toList() ??
        [];
  }

  static List<Entry> fromVariableConsumptionListMap(Map<String, dynamic> map) {
    return (map['variableConsumptionList'] as List<dynamic>?)
        ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
        .toList() ??
        [];
  }

  // 계산 메서드
  int get totalFixedIncome => fixedIncomes.fold(0, (sum, e) => sum + e.amount);
  int get totalFixedConsumption => fixedConsumptions.fold(0, (sum, e) => sum + e.amount);
  int get totalVariableConsumption => variableConsumptions.fold(0, (sum, e) => sum + e.amount);
  int get totalAdditionalIncome => additionalIncomeList.fold(0, (sum, e) => sum + e.amount);
  int get totalAdditionalConsumption => additionalConsumptionList.fold(0, (sum, e) => sum + e.amount);

  int getInstallmentConsumptionAmount(DateTime date, DateTime endDate) {
    int total = 0;

    for (var entry in installmentConsumptions) {
      if (entry.dateTime == null) continue;
      if (entry.dateTime!.isAfter(date) || entry.dateTime!.isAtSameMomentAs(date)) {
        final days = endDate.difference(entry.dateTime!).inDays;
        if (days > 0) {
          total += (entry.amount / days).floor();
        }
      }
    }

    return total;
  }

  int getInstallmentIncomeAmount(DateTime date, DateTime endDate) {
    int total = 0;

    for (var entry in additionalIncomeList) {
      if (entry.dateTime == null) continue;
      if (entry.dateTime!.isAfter(date) || entry.dateTime!.isAtSameMomentAs(date)) {
        final days = endDate.difference(entry.dateTime!).inDays;
        if (days > 0) {
          total += (entry.amount / days).floor();
        }
      }
    }

    return total;
  }
}
