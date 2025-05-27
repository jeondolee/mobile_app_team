import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/plan_info.dart';

class GetFixedIncomePage extends StatefulWidget {
  final PlanInfo planInfo;

  const GetFixedIncomePage({super.key, required this.planInfo});

  @override
  State<GetFixedIncomePage> createState() => _GetFixedIncomePageState();
}

class _GetFixedIncomePageState extends State<GetFixedIncomePage> {
  final List<String> _dropdownOptions = [
    '근로소득', '사업', '연금(보험)', '임대소득', '투자수익', '지적재산권', '기타'
  ];

  final List<String?> _dropdownSelections = List.generate(3, (_) => null);
  final List<TextEditingController> _dropdownControllers =
  List.generate(3, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _dropdownControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool get _isFormValid {
    return _dropdownControllers.any((c) => c.text.trim().isNotEmpty);
  }

  Color _getBackgroundColor(String text) {
    return text.trim().isEmpty
        ? const Color(0xFFEDEDED)
        : const Color(0xFFEDF4FF);
  }

  @override
  Widget build(BuildContext context) {
    final planInfo = widget.planInfo;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '한 달 고정 수입을 \n입력해주세요',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // const Text(
              //   '한 달에 한 번 정기적으로 받는 수입을 의미해요',
              //   style: TextStyle(fontSize: 13, color: Colors.grey),
              // ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: _dropdownSelections.length,
                  itemBuilder: (context, index) {
                    final selectedValues = _dropdownSelections
                        .whereType<String>()
                        .toList()
                      ..remove(_dropdownSelections[index]);

                    final filteredOptions = _dropdownOptions
                        .where((option) =>
                    !selectedValues.contains(option) ||
                        option == _dropdownSelections[index])
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () async {
                                final picked =
                                await showModalBottomSheet<String>(
                                  context: context,
                                  builder: (context) => ListView(
                                    padding: const EdgeInsets.all(16),
                                    children: filteredOptions
                                        .map(
                                          (option) => ListTile(
                                        title: Text(option),
                                        onTap: () =>
                                            Navigator.pop(context, option),
                                      ),
                                    )
                                        .toList(),
                                  ),
                                );

                                if (picked != null) {
                                  setState(() {
                                    _dropdownSelections[index] = picked;
                                  });
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                  Border.all(color: Colors.grey[300]!),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _dropdownSelections[index] ?? '선택',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: _getBackgroundColor(
                                    _dropdownControllers[index].text),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              child: TextFormField(
                                controller: _dropdownControllers[index],
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                                decoration: const InputDecoration(
                                  hintText: 'ex. 200,000',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // if (!_isFormValid)
              //   const Padding(
              //     padding: EdgeInsets.only(bottom: 8.0),
              //     child: Text(
              //       '근로소득, 사업/기타 입력 후 다음 버튼을 눌러주세요',
              //       style: TextStyle(fontSize: 12, color: Colors.grey),
              //     ),
              //   ),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isFormValid ? () async {
                      // 고정 수입 리스트를 생성
                      final fixedIncomes = <Map<String, dynamic>>[];
                      for (int i = 0; i < _dropdownControllers.length; i++) {
                        final source = _dropdownSelections[i];
                        final amount = _dropdownControllers[i].text.trim();

                        if (source != null && amount.isNotEmpty) {
                          fixedIncomes.add({
                            'source': source,
                            'amount': int.parse(amount),
                          });
                        }
                      }

                      // 기존 PlanInfo에 fixedIncomes 추가
                      planInfo.fixedIncomes = fixedIncomes;

                      // 현재 유저 ID 가져오기
                      final uid = FirebaseAuth.instance.currentUser?.uid;
                      if (uid == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('로그인이 필요합니다.')),
                        );
                        return;
                      }

                      // Firestore에 저장
                      try {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('plans')
                            .doc('main')
                            .set(planInfo.toMap(), SetOptions(merge: true)); // .set(planInfo.toMap() 만 사용시 기존 doc 덮어쓰기 됨


                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('플랜이 저장되었습니다!')),
                        );

                        // 다음 화면으로 이동
                        Navigator.of(context).pushReplacementNamed('/consultOrNot'); // 원하는 페이지로 수정
                      } catch (e) {
                        print('플랜 저장 실패: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('저장 실패: $e')),
                        );
                      }
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid
                          ? const Color(0xFF0062FF)
                          : const Color(0xFFF2F2F2),
                      foregroundColor: _isFormValid
                          ? Colors.white
                          : const Color(0xFFAAAAAA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('다음'),
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
