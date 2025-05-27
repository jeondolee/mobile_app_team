import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/VariableExpense_info.dart';

class AutoRegisterSelectPage extends StatefulWidget {
  final List<ExpenseItem> expenses;

  const AutoRegisterSelectPage({super.key, required this.expenses});

  @override
  State<AutoRegisterSelectPage> createState() => _AutoRegisterSelectPageState();
}

class _AutoRegisterSelectPageState extends State<AutoRegisterSelectPage> {
  final formatter = NumberFormat('#,###');
  final Set<ExpenseItem> selectedItems = {};

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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '설정하신 변동소비 중\n자동등록할 소비를 체크해 주세요',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // 항목 리스트
              ...widget.expenses.map((item) {
                final isSelected = selectedItems.contains(item);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF2F4F6),
                  ),
                  child: CheckboxListTile(
                    value: isSelected,
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          selectedItems.add(item);
                        } else {
                          selectedItems.remove(item);
                        }
                      });
                    },
                    title: Text('${item.category}  ${formatter.format(item.amount)}원'),
                    activeColor: const Color(0xFF0062FF),
                    controlAffinity: ListTileControlAffinity.leading,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                );
              }),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: selectedItems.isNotEmpty
                      ? () {
                    Navigator.pushNamed(
                      context,
                      '/autoRegisterSummary',
                      arguments: selectedItems.toList(),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedItems.isNotEmpty ? const Color(0xFF0062FF) : const Color(0xFFF2F2F2),
                    foregroundColor: selectedItems.isNotEmpty ? Colors.white : const Color(0xFFAAAAAA),
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
