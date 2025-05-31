class Entry {
  final int idx;
  final int amount;
  final String category;
  final String note;
  final String type; // fixed, variable, additional

  Entry({
    required this.idx,
    required this.amount,
    required this.category,
    this.note = '',
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'idx': idx,
      'amount': amount,
      'category': category,
      'note': note,
      'type': type,
    };
  }

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      idx: map['idx'] ?? 0,
      amount: map['amount'] ?? 0,
      category: map['category'] ?? '',
      note: map['note'] ?? '',
      type: map['type'] ?? '',
    );
  }
}
