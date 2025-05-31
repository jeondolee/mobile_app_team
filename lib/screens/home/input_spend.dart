import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputSpendScreen extends StatefulWidget {
  const InputSpendScreen({super.key});

  @override
  State<InputSpendScreen> createState() => _InputSpendScreenState();
}

class _InputSpendScreenState extends State<InputSpendScreen> {
  String? _selectedCategory1;
  String? _selectedCategory2;
  String? _selectedCategory3;

  final List<String> _categories = [
    '식비',
    '교통',
    '쇼핑',
    '의료',
    '교육',
    '여가',
    '기타'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('오늘의 소비 입력'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            _buildCategoryDropdown(
              selectedValue: _selectedCategory1,
              onChanged: (value) => setState(() => _selectedCategory1 = value),
            ),
            SizedBox(height: 8.h),
            _buildContentField(),
            SizedBox(height: 8.h),
            _buildAmountField(),
            SizedBox(height: 16.h),
            
            _buildCategoryDropdown(
              selectedValue: _selectedCategory2,
              onChanged: (value) => setState(() => _selectedCategory2 = value),
            ),
            SizedBox(height: 8.h),
            _buildContentField(),
            SizedBox(height: 8.h),
            _buildAmountField(),
            SizedBox(height: 16.h),
            
            _buildCategoryDropdown(
              selectedValue: _selectedCategory3,
              onChanged: (value) => setState(() => _selectedCategory3 = value),
            ),
            SizedBox(height: 8.h),
            _buildContentField(),
            SizedBox(height: 8.h),
            _buildAmountField(),
            
            const Spacer(),
            _buildRecordButton(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown({
    String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownMenu<String>(
          initialSelection: selectedValue,
          onSelected: onChanged,
          width: double.infinity,
          hintText: '카테고리 선택',
          dropdownMenuEntries: _categories.map((category) {
            return DropdownMenuEntry<String>(
              value: category,
              label: category,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: '내용',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: '금액',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          suffixText: '원',
        ),
      ),
    );
  }

  Widget _buildRecordButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          // TODO: 기록하기 로직 구현
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[200],
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          '기록하기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
} 