import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/plan_info.dart';
import '../../../models/refData.dart';
import '../../../models/entry.dart';
import '../../../models/VariableExpense_info.dart';

class VariableExpensePage extends StatefulWidget {
  final PlanInfo planInfo;
  final RefData refData;

  const VariableExpensePage({
    super.key,
    required this.planInfo,
    required this.refData,
  });

  @override
  State<VariableExpensePage> createState() => _VariableExpensePageState();
}

class _VariableExpensePageState extends State<VariableExpensePage> {
  late int expectedLivingCost;
  final List<String> dropdownOptions = ['식비', '교통비', '경조사비', '여가/오락', '병원비', '기타'];
  final List<String?> selectedItems = [];
  final List<TextEditingController> controllers = [];

  final currency = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');
  final commaFormatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    expectedLivingCost = widget.planInfo.monthlyLimit;
    _addNewRow(); // 첫 줄 추가
  }

  void _addNewRow() {
    setState(() {
      selectedItems.add(null);
      final controller = TextEditingController();
      controller.addListener(() => setState(() {}));
      controllers.add(controller);
    });
  }

  int get totalEnteredAmount {
    return controllers.fold(0, (sum, controller) {
      final text = controller.text.trim().replaceAll(',', '');
      if (text.isEmpty) return sum;
      return sum + (int.tryParse(text) ?? 0);
    });
  }

  int get remainingAmount => expectedLivingCost - totalEnteredAmount;

  bool get isFormValid {
    return controllers.any((c) => c.text.trim().isNotEmpty);
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '변동 가능성이 있는\n소비를 입력해주세요',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w800, //ExtraBold
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 12,
                    color: Color(0xFF9A9A9A),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '지출 금액을 조정할 수 있는 항목(소비)를 의미해요',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      color: Color(0xFF9A9A9A),
                      fontWeight: FontWeight.bold, //ExtraBold
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF4FF),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    const Text(
                      '앞으로의 생활비 ',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currency.format(remainingAmount),
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.bold,
                        color: remainingAmount >= 0 ? const Color(0xFF0062FF) : Colors.red,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: controllers.length,
                  itemBuilder: (context, index) {
                    final selected = selectedItems[index];
                    final controller = controllers[index];
                    final isFirstRow = index == 0;
                    final isSelected = selected != null;
                    final shouldFade = !isFirstRow && !isSelected;

                    return Opacity(
                      opacity: shouldFade ? 0.4 : 1.0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  final picked = await showModalBottomSheet<String>(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                    ),
                                    builder: (context) => ListView(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      children: dropdownOptions.map((option) {
                                        return RadioListTile<String>(
                                          value: option,
                                          groupValue: selected,
                                          title: Text(option),
                                          activeColor: Colors.blue,
                                          visualDensity: VisualDensity.compact,
                                          onChanged: (value) {
                                            Navigator.pop(context, value);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  );

                                  if (picked != null) {
                                    setState(() {
                                      selectedItems[index] = picked;
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(selected ?? '선택', style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      const Spacer(),
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
                                  borderRadius: BorderRadius.circular(12),
                                  color: controller.text.trim().isEmpty
                                      ? const Color(0xFFEDEDED)
                                      : const Color(0xFFEDF4FF),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: TextFormField(
                                  controller: controller,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    final raw = value.replaceAll(',', '');
                                    final number = int.tryParse(raw);
                                    if (number != null) {
                                      final formatted = commaFormatter.format(number);
                                      controller.value = TextEditingValue(
                                        text: formatted,
                                        selection: TextSelection.collapsed(offset: formatted.length),
                                      );
                                    }

                                    final isLast = index == controllers.length - 1;
                                    final isFilled = controller.text.trim().isNotEmpty;

                                    if (isLast && isFilled) {
                                      _addNewRow();
                                    }

                                    setState(() {});
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'ex. 90,000',
                                    hintStyle: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF909090),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: (isFormValid && remainingAmount >= 0)
                      ? () {
                    final expenseList = <Entry>[];

                    for (int i = 0; i < controllers.length; i++) {
                      final selected = selectedItems[i];
                      final controller = controllers[i];
                      final text = controller.text.replaceAll(',', '').trim();
                      final amount = int.tryParse(text);

                      if (selected != null && text.isNotEmpty && amount != null) {
                        expenseList.add(Entry(
                          idx: i,
                          amount: amount,
                          category: selected,
                          type: EntryType.variable,
                        ));
                      }
                    }

                    widget.refData.variableConsumptions = expenseList;

                    // 요약 페이지로 이동
                    Navigator.of(context).pushNamed(
                      '/summary',
                      arguments: {
                        'planInfo': widget.planInfo,
                        'refData': widget.refData,
                      },
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (isFormValid && remainingAmount >= 0)
                        ? const Color(0xFF0062FF)
                        : const Color(0xFFF2F2F2),
                    foregroundColor: (isFormValid && remainingAmount >= 0)
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
