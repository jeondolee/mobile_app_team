import 'package:flutter/material.dart';

class SpendingItem {
  String category;
  String note;
  String type = '지출';
  int amount;
  DateTime date;

  SpendingItem({
    required this.category,
    required this.note,
    required this.amount,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'note': note,
      'type': '지출',
      'amount': amount,
      'date': date,
    };
  }
}

class Spending extends StatefulWidget {
  const Spending({super.key});

  @override
  State<Spending> createState() => _SpendingState();
}

class _SpendingState extends State<Spending> {
  String? selectedCategory;
  final List<String> category = ['용돈', '장학금', '지원금', '기타'];
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  List<SpendingItem> SpendingItems = [];

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _addDepositItem() {
    if (selectedCategory == null ||
        _noteController.text.isEmpty ||
        _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('모든 항목을 입력해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      SpendingItems.add(
        SpendingItem(
          category: selectedCategory!,
          note: _noteController.text,
          amount: int.parse(_amountController.text.replaceAll(',', '')),
        ),
      );
      
      // 입력 필드 초기화
      selectedCategory = null;
      _noteController.clear();
      _amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('추가 지출'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 46.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownMenu<String>(
                initialSelection: selectedCategory,
                hintText: '카테고리 선택',
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'Pretendard',
                ),
                menuStyle: MenuStyle(
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                width: MediaQuery.of(context).size.width - 92,
                inputDecorationTheme: InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                dropdownMenuEntries: category.map(
                  (type) => DropdownMenuEntry(
                    value: type,
                    label: type,
                  ),
                ).toList(),
                onSelected: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                filled: true,
                hintText: '내용',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                hintText: 'ex. 90,000',
                suffixText: '원',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // 입금 내역 리스트
            Expanded(
              child: ListView.builder(
                itemCount: SpendingItems.length,
                itemBuilder: (context, index) {
                  final item = SpendingItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(item.category),
                      subtitle: Text(item.note),
                      trailing: Text('${item.amount.toString()}원'),
                      leading: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            SpendingItems.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            TextButton(
              onPressed: _addDepositItem,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text('소비내역 추가+'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: SpendingItems.isEmpty ? null : () {
                  Navigator.pushNamed(
                    context,
                    '/Spendingamount_change_choice',
                    arguments: SpendingItems,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: SpendingItems.isEmpty
                      ? const Color(0xFFF4F4F4)
                      : Theme.of(context).primaryColor,
                  foregroundColor: SpendingItems.isEmpty
                      ? const Color(0xFF9E9E9E)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '다음',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
} 