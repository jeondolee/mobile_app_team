import 'package:cloud_firestore/cloud_firestore.dart';
import 'entry.dart';

class RefDate {
  String planID;
  List<Entry> fixedIncomes;
  List<Entry> fixedConsumptions;
  List<Entry> variableConsumptions;

  RefDate({
    this.planID = '', // required가 좋을 것 같기는 하나 일단은...
    this.fixedIncomes = const [],
    this.fixedConsumptions = const [],
    this.variableConsumptions = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'fixedIncomes': fixedIncomes.map((e) => e.toMap()).toList(),
      'fixedConsumptions': fixedConsumptions.map((e) => e.toMap()).toList(),
      'variableConsumptions': variableConsumptions.map((e) => e.toMap()).toList(),
    };
  }

  factory RefDate.fromMap(Map<String, dynamic> map) {
    return RefDate(
      fixedIncomes: (map['fixedIncomes'] as List<dynamic>?)
          ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [],
      fixedConsumptions: (map['fixedConsumptions'] as List<dynamic>?)
          ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [],
      variableConsumptions: (map['variableConsumptions'] as List<dynamic>?)
          ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}
