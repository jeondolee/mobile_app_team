import 'package:flutter/material.dart';
import '../../../models/entry.dart';
import '../../../models/dateEntry.dart';

class Deposit extends StatefulWidget {
  final DateEntry dateEntry;

  const Deposit({super.key, required this.dateEntry});

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  String? selectedCategory;
  final List<String> category = ['용돈', '장학금', '지원금', '기타'];
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  late DateEntry depositEntry;

  @override
  void initState() {
    super.initState();
    depositEntry = DateEntry(date: widget.dateEntry.date, dateEntry: []);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _addDepositEntry() {
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
      depositEntry.dateEntry.add(
        Entry(
          idx: depositEntry.dateEntry.length + 1,
          category: selectedCategory!,
          note: _noteController.text,
          amount: int.parse(_amountController.text.replaceAll(',', '')),
          type: EntryType.additional,
        ),
      );
      selectedCategory = null;
      _noteController.clear();
      _amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localTheme = ThemeData(
      fontFamily: 'Pretendard',
      useMaterial3: true,
      primaryColor: const Color(0xFF2D64D8),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2D64D8),
        primary: const Color(0xFF2D64D8),
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF232020)),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF232020),
          letterSpacing: -2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF4F4F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Color(0xFF909090),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Color(0xFF232020),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) =>
            states.contains(MaterialState.disabled) ? const Color(0xFFF4F4F4) : const Color(0xFF2D64D8),
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) =>
            states.contains(MaterialState.disabled) ? const Color(0xFF9E9E9E) : Colors.white,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          minimumSize: MaterialStateProperty.all(const Size.fromHeight(50)),
          textStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
          foregroundColor: const Color(0xFFB0B0B0),
        ),
      ),
    );

    return Theme(
      data: localTheme,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('추가 수입'),
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
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  dropdownMenuEntries: category
                      .map((type) => DropdownMenuEntry(value: type, label: type))
                      .toList(),
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
                decoration: const InputDecoration(hintText: '내용'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'ex. 90,000',
                  suffixText: '원',
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: depositEntry.dateEntry.length,
                  itemBuilder: (context, index) {
                    final item = depositEntry.dateEntry[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(item.category),
                        subtitle: Text(item.note),
                        trailing: Text('${item.amount}원'),
                        leading: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              depositEntry.dateEntry.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: _addDepositEntry,
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('소비내역 추가+'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: depositEntry.dateEntry.isEmpty
                      ? null
                      : () {
                    Navigator.pushNamed(
                      context,
                      '/deposit_amount_change_choice',
                      arguments: depositEntry,
                    );
                  },
                  child: const Text(
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
      ),
    );
  }
}
