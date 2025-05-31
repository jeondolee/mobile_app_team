import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpendListScreen extends StatefulWidget {
  const SpendListScreen({super.key});

  @override
  State<SpendListScreen> createState() => _SpendListScreenState();
}

class _SpendListScreenState extends State<SpendListScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의소비'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            _buildSpendItem(
              category: '점심식사',
              amount: '8,000원',
            ),
            _buildDivider(),
            _buildSpendItem(
              category: '택시',
              amount: '12,000원',
            ),
            _buildDivider(),
            _buildTotalAmount(amount: '20,000원'),
            const Spacer(),
            _buildAddButton(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendItem({
    required String category,
    required String amount,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              category,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey[200],
    );
  }

  Widget _buildTotalAmount({required String amount}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Text(
            '합계',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/input_spend');
      },
      child: Text(
        '소비내역 추가 +',
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey[600],
        ),
      ),
    );
  }
} 