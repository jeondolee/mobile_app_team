import 'package:cloud_firestore/cloud_firestore.dart';
import 'entry.dart';
/*
await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .collection('plans')
    .doc('myPlan')
    .set({
  'incomes_custom': refDate.toMap()['fixedIncomes'],
  'consumptions_custom': refDate.toMap()['fixedConsumptions'],
});
--------------------
-
final incomeEntry = DateEntry(dateEntry: [...]);
final consumptionEntry = DateEntry(dateEntry: [...]);

await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .collection('plans')
    .doc('main')
    .set({
  'date_incomes': incomeEntry.toMap(),
  'date_consumptions': consumptionEntry.toMap(),
});
--------------------
final map = snapshot.data();
final incomeEntry = DateEntry.fromMap(map['date_incomes']);
final consumptionEntry = DateEntry.fromMap(map['date_consumptions']);
 */

class DateEntry {
  List<Entry> dateEntry;

  DateEntry({
    this.dateEntry = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'dateEntry': dateEntry.map((e) => e.toMap()).toList(),
    };
  }

  factory DateEntry.fromMap(Map<String, dynamic> map) {
    return DateEntry(
      dateEntry: (map['dateEntry'] as List<dynamic>?)
          ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

