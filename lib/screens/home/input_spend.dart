import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../models/entry.dart';
import '../../../models/dateEntry.dart';

class InputSpendScreen extends StatefulWidget {
  final DateEntry dateEntry;

  const InputSpendScreen({
    super.key,
    required this.dateEntry,
  });

  @override
  State<InputSpendScreen> createState() => _InputSpendScreenState();
}

class _InputSpendScreenState extends State<InputSpendScreen> {
  final List<String> _dropdownOptions = [
    '식비', '교통', '쇼핑', '의료', '교육', '여가', '기타'
  ];

  final List<String?> _dropdownSelections = [];
  final List<TextEditingController> _amountControllers = [];
  final List<TextEditingController> _noteControllers = [];

  @override
  void initState() {
    super.initState();
    _addNewRow();
  }

  void _addNewRow() {
    setState(() {
      _dropdownSelections.add(null);
      final amountController = TextEditingController();
      amountController.addListener(() => setState(() {}));
      _amountControllers.add(amountController);
      _noteControllers.add(TextEditingController());
    });
  }

  bool get _isFormValid {
    for (int i = 0; i < _amountControllers.length; i++) {
      if (_amountControllers[i].text.trim().isNotEmpty && _dropdownSelections[i] != null) {
        return true;
      }
    }
    return false;
  }

  Future<void> _saveToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final planID = userDoc.data()?['planID'];
    if (planID == null) return;

    final String searchDate = DateFormat('yyyy-MM-dd').format(widget.dateEntry.date!);

    // 기존 항목 불러오기
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('records')
        .doc(planID)
        .collection('consumption')
        .doc(searchDate)
        .get();

    List<Entry> existingEntries = [];
    if (docSnapshot.exists && docSnapshot.data() != null) {
      final existingData = DateEntry.fromMap(docSnapshot.data()!);
      existingEntries = existingData.dateEntry;
    }

    // 새 항목 생성
    final List<Entry> newEntries = [];
    for (int i = 0; i < _amountControllers.length; i++) {
      final category = _dropdownSelections[i];
      final amountText = _amountControllers[i].text.trim();
      final note = _noteControllers[i].text.trim();
      if (category != null && amountText.isNotEmpty) {
        final amount = int.tryParse(amountText.replaceAll(',', '')) ?? 0;
        newEntries.add(Entry(
          idx: existingEntries.length + i, // 기존 인덱스 이후로 붙이기
          amount: amount,
          category: category,
          note: note,
          type: EntryType.variable,
        ));
      }
    }

    // 기존 데이터, 신규 데이터 병합
    final allEntries = [...existingEntries, ...newEntries];

    final entryToSave = DateEntry(
      date: widget.dateEntry.date,
      dateEntry: allEntries,
    );

    // 누적 데이터 저장
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('records')
        .doc(planID)
        .collection('consumption')
        .doc(searchDate)
        .set(entryToSave.toMap());
  }

  @override
  void dispose() {
    for (final c in _amountControllers) {
      c.dispose();
    }
    for (final c in _noteControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '소비 입력',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 날짜 표시
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Text(
                  DateFormat('yyyy년 MM월 dd일').format(widget.dateEntry.date!),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // 항목 리스트
              Expanded(
                child: ListView.builder(
                  itemCount: _dropdownSelections.length,
                  itemBuilder: (context, index) {
                    final isLast = index == _dropdownSelections.length - 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 카테고리
                        GestureDetector(
                          onTap: () async {
                            final picked = await showModalBottomSheet<String>(
                              context: context,
                              builder: (context) => ListView(
                                padding: const EdgeInsets.all(16),
                                children: _dropdownOptions.map((option) {
                                  return ListTile(
                                    title: Text(option),
                                    onTap: () => Navigator.pop(context, option),
                                  );
                                }).toList(),
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                _dropdownSelections[index] = picked;
                              });
                              if (isLast && _amountControllers[index].text.trim().isNotEmpty) {
                                _addNewRow();
                              }
                            }
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  _dropdownSelections[index] ?? '카테고리 선택',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),

                        // 금액
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: _amountControllers[index],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '금액 입력',
                              border: InputBorder.none,
                            ),
                            onChanged: (_) {
                              if (isLast &&
                                  _dropdownSelections[index] != null &&
                                  _amountControllers[index].text.trim().isNotEmpty) {
                                _addNewRow();
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: 8),

                        // 비고
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: _noteControllers[index],
                            decoration: const InputDecoration(
                              hintText: '세부 내용',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),

              // 저장 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: (_isFormValid)
                      ? () async {
                    await _saveToFirestore();
                    if (!mounted) return;
                    Navigator.pop(context); // 저장 후 이전 페이지로 이동
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_isFormValid)
                        ? const Color(0xFF0062FF)
                        : const Color(0xFFF2F2F2),
                    foregroundColor: (_isFormValid)
                        ? Colors.white
                        : const Color(0xFFAAAAAA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('저장'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
