import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../models/dateEntry.dart';

class SpendListScreen extends StatefulWidget {
  final DateEntry dateEntry;

  const SpendListScreen({
    super.key,
    required this.dateEntry,
  });

  @override
  State<SpendListScreen> createState() => _SpendListScreenState();
}

class _SpendListScreenState extends State<SpendListScreen> {
  late DateEntry dateEntry;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    dateEntry = widget.dateEntry; // 기본값 복사
    loadDateEntry(widget.dateEntry.date!); // 날짜 기준으로 Firestore에서 최신 데이터 불러오기
  }

  Future<void> loadDateEntry(DateTime inputDate) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final planID = userDoc.data()?['planID'];
    if (planID == null) return;

    String searchDate = DateFormat('yyyy-MM-dd').format(inputDate);

    final docDateEntry = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('records')
        .doc(planID)
        .collection('consumption')
        .doc(searchDate)
        .get();

    setState(() {
      if (docDateEntry.exists && docDateEntry.data() != null) {
        final newEntry = DateEntry.fromMap(docDateEntry.data()!);
        newEntry.date = DateTime.parse(searchDate);
        dateEntry = newEntry;
      } else {
        dateEntry = DateEntry(
          date: DateTime.parse(searchDate),
          dateEntry: [],
        );
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 소비'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Text(
                    DateFormat('yyyy년 MM월 dd일').format(widget.dateEntry.date!),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            _buildSpendList(),
            _buildTotalAmount(
              amount: '${dateEntry.amount.toString().replaceAllMapped(
                  RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}원',
            ),
            const Spacer(),
            _variableButton(),
            SizedBox(height: 8.h),
            _additionalButton(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendList() {
    final entries = dateEntry.dateEntry;

    if (entries.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text(
          '소비 내역이 없습니다.',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < entries.length; i++) ...[
          _buildSpendItem(
            category: entries[i].category,
            amount: '${entries[i].amount.toString().replaceAllMapped(
                RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}원',
          ),
          if (i != entries.length - 1) _buildDivider(),
        ]
      ],
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

  Widget _variableButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            '/input_spend',
            arguments: dateEntry,
          );
          // 돌아온 후 최신화
          await loadDateEntry(dateEntry.date!);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: const BorderSide(color: Colors.grey),
          ),
          textStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: const Text('소비내역 추가 +'),
      ),
    );
  }

  Widget _additionalButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/additional_choice',
            arguments: dateEntry,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: const BorderSide(color: Colors.grey),
          ),
          textStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: const Text('추가 수입/지출 추가 +'),
      ),
    );
  }
}
