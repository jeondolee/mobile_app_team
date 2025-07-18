import 'package:flutter/material.dart';

import '../../../models/plan_info.dart';
import '../../../models/entry.dart';
import '../../../models/refData.dart';

class FixedIncomePage extends StatefulWidget {
  final PlanInfo planInfo;

  const FixedIncomePage({
    super.key,
    required this.planInfo,
  });

  @override
  State<FixedIncomePage> createState() => _FixedIncomePageState();
}

class _FixedIncomePageState extends State<FixedIncomePage> {
  final List<String> _dropdownOptions = [
    '근로소득', '용돈' ,'사업', '연금(보험)', '임대소득', '투자수익', '지적재산권', '기타'
  ];

  final List<String?> _dropdownSelections = [];
  final List<TextEditingController> _dropdownControllers = [];

  @override
  void initState() {
    super.initState();
    _addNewRow(); // 초기 줄 추가
  }

  void _addNewRow() {
    setState(() {
      _dropdownSelections.add(null);
      final controller = TextEditingController();
      controller.addListener(() => setState(() {}));
      _dropdownControllers.add(controller);
    });
  }

  bool get _isFormValid {
    for (int i = 0; i < _dropdownControllers.length; i++) {
      final text = _dropdownControllers[i].text.trim();
      final selected = _dropdownSelections[i];
      if (text.isNotEmpty && selected != null) return true;
    }
    return false;
  }

  Color _getBackgroundColor(String text) {
    return text.trim().isEmpty ? const Color(0xFFEDEDED) : const Color(0xFFEDF4FF);
  }

  @override
  void dispose() {
    for (var controller in _dropdownControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planInfo = widget.planInfo;
    final originalRefData = RefData(planID: widget.planInfo.planID);

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
              const Text(
                 '한 달에 한 번 정기적으로 받는 수입을 의미해요',
                 style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: _dropdownSelections.length,
                  itemBuilder: (context, index) {
                    final selected = _dropdownSelections[index];
                    final controller = _dropdownControllers[index];
                    final isLast = index == _dropdownSelections.length - 1;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
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

                                  if (isLast && controller.text.trim().isNotEmpty) {
                                    _addNewRow();
                                  }
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      selected ?? '선택',
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
                                color: _getBackgroundColor(controller.text),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: TextFormField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'ex. 200000',
                                  border: InputBorder.none,
                                ),
                                onChanged: (_) {
                                  if (isLast &&
                                      _dropdownSelections[index] != null &&
                                      controller.text.trim().isNotEmpty) {
                                    _addNewRow();
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isFormValid
                      ? () {
                    final fixedIncomes = <Entry>[];

                    for (int i = 0; i < _dropdownControllers.length; i++) {
                      final source = _dropdownSelections[i];
                      final amountText = _dropdownControllers[i].text.trim();

                      if (source != null && amountText.isNotEmpty) {
                        final amount = int.tryParse(amountText.replaceAll(',', '')) ?? 0;

                        fixedIncomes.add(Entry(
                          idx: i,
                          amount: amount,
                          category: source,
                          type: EntryType.fixed,
                        ));
                      }
                    }

                    final updatedRefData = RefData(
                      planID: originalRefData.planID,
                      fixedIncomes: fixedIncomes,
                    );

                    planInfo.fixedIncomeAmount = updatedRefData.totalFixedIncome;

                    Navigator.of(context).pushNamed(
                      '/FixedConsumption',
                      arguments: {
                        'planInfo': planInfo,
                        'refData': updatedRefData,
                      },
                    );
                  }
                      : null,
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
