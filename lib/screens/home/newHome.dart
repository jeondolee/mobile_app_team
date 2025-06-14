import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widget/mainGraph.dart';
import '../../models/plan_info.dart';
import '../../models/dateEntry.dart';
import '../../models/refData.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlanInfo? _planInfo;
  RefData? refData;
  bool _isLoading = true;
  bool dailyState = true;
  int dayCount = 0;
  DateEntry dateEntry = DateEntry(dateEntry: []);
  final DateTime nowDate = DateTime.now();
  DateTime searchDate =  DateTime.now();
  int weekAmount = 0;
  DateTime searchWeek = DateTime.now(); // getWeekNumber과 연결


  @override
  void initState() {
    super.initState();
    _loadPlanInfo();
    loadFullRefData();
    loadDateEntry(nowDate);
    loadWeekAmount(searchWeek);
  }

  Future<void> _loadPlanInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final planID = userDoc.data()?['planID'];
    if (planID == null) return;

    final docPlanInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(planID)
        .get();

    if (docPlanInfo.exists && docPlanInfo.data() != null) {
      setState(() {
        _planInfo = PlanInfo.fromMap(docPlanInfo.data()!);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<RefData?> loadFullRefData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final planID = userDoc.data()?['planID'];
    if (planID == null) return null;

    final basePath = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('records')
        .doc(planID)
        .collection('refData');

    // 각각의 문서를 병렬로 가져오기
    final docs = await Future.wait([
      basePath.doc('fixedIncomeData').get(),
      basePath.doc('fixedConsumptionData').get(),
      basePath.doc('variableConsumptionData').get(),
      basePath.doc('installmentConsumptionData').get(),
    ]);

    final loadedRefData = RefData(
      planID: planID,
      fixedIncomes: docs[0].exists ? RefData.fromFixedIncomesMap(docs[0].data()!) : [],
      fixedConsumptions: docs[1].exists ? RefData.fromFixedConsumptionsMap(docs[1].data()!) : [],
      variableConsumptions: docs[2].exists ? RefData.fromVariableConsumptionsMap(docs[2].data()!) : [],
      installmentConsumptions: docs[3].exists ? RefData.fromInstallmentConsumptionsMap(docs[3].data()!) : [],
    );

    setState(() {
      refData = loadedRefData;
    });
  }

  // inputDate에 해당하는 DateEntry를 불러옴
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

    DateEntry newEntry;
    if (docDateEntry.exists && docDateEntry.data() != null) {
      newEntry = DateEntry.fromMap(docDateEntry.data()!);
      newEntry.date = DateTime.parse(searchDate);
    } else {
      newEntry = DateEntry(
        date: DateTime.parse(searchDate),
        dateEntry: [],
      );
    }

    // dailyState 계산은 newEntry 기준으로
    if (_planInfo != null) {
      final dailyLimit = _planInfo!.getDailyLimit(inputDate);
      dailyState = newEntry.amount <= dailyLimit;
    }

    setState(() {
      dateEntry = newEntry;
    });
  }

  // 주차 누적금액 계산 (inputDate가 속한 해당 주차의 월요일 ~ inputDate까지 합을 계산)
  Future<void> loadWeekAmount(
      DateTime inputDate, {
        DateTime? startDate,
        DateTime? endDate,
      }) async {
    int totalAmount = 0; // 로컬 변수에 누적

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final planID = userDoc.data()?['planID'];
    if (planID == null) return;

    final weekDates = _getFullWeekDates(inputDate);

    for (DateTime date in weekDates) {
      // 날짜 범위 필터링
      if (startDate != null && date.isBefore(startDate)) continue;
      if (endDate != null && date.isAfter(endDate)) continue;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('records')
          .doc(planID)
          .collection('consumption')
          .doc(DateFormat('yyyy-MM-dd').format(date))
          .get();

      if (doc.exists) {
        final entry = DateEntry.fromMap(doc.data()!);
        totalAmount += entry.amount;
      }
    }

    // 루프 끝나고 UI에 반영
    setState(() {
      weekAmount = totalAmount;
    });
  }


  // 주차에 해당하는 날짜 리스트 리턴(월~입력일까지)
  // => sunday or today를 받아서 해당 주차의 날짜 리스트 받을 것
  List<DateTime> _getFullWeekDates(DateTime inputDate) {
    final monday = inputDate.subtract(Duration(days: inputDate.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  // 주차 누적 금액 날짜 이동을 위해
  // inputDate 직전의 일요일을 반환
  DateTime getPreviousWeekSunday(DateTime inputDate) {
    final currentMonday = inputDate.subtract(Duration(days: inputDate.weekday - 1));
    final previousSunday = currentMonday.subtract(Duration(days: 1));

    return previousSunday;
  }

  // inputDate 이후의
  DateTime getNextWeekSunday(DateTime inputDate, DateTime nowDate) {
    final currentMonday = inputDate.subtract(Duration(days: inputDate.weekday - 1));
    final nextSunday = currentMonday.add(Duration(days: 13)); // 다음 주 일요일

    return nextSunday.isAfter(nowDate) ? nowDate : nextSunday;
  }


  // 일일 소비 날짜 form
  String formatToKoreanDate(DateTime date) {
    return DateFormat('M월 d일').format(date);
  }

  // 일일 소비 날짜 이동 계산
  DateTime addDays(DateTime date, int dayCount) {
    DateTime destDate = date.add(Duration(days: dayCount));
    return destDate;
  }

  // dailyLimit 계산을 위한 월별 일수
  int getDaysInMonth(DateTime date) {
    DateTime firstDayThisMonth = DateTime(date.year, date.month, 1);
    DateTime firstDayNextMonth = (date.month < 12)
        ? DateTime(date.year, date.month + 1, 1)
        : DateTime(date.year + 1, 1, 1);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  // n주차 계산
  // currentDate가 속한 월요일을 주차의 구해서 startDate가 속한 주차와 차이를 비교
  int getWeekNumber(DateTime startDate, DateTime currentDate) {
    DateTime startMonday = startDate.subtract(Duration(days: startDate.weekday - 1));
    startMonday = DateTime(startMonday.year, startMonday.month, startMonday.day);

    DateTime currentMonday = currentDate.subtract(Duration(days: currentDate.weekday - 1));
    currentMonday = DateTime(currentMonday.year, currentMonday.month, currentMonday.day);

    if (currentMonday.isBefore(startMonday)) return 0;

    int dayDiff = currentMonday.difference(startMonday).inDays;
    return (dayDiff ~/ 7) + 1;
  }

  bool isWithinDailyLimit(DateEntry entry, PlanInfo plan, DateTime date) {
    final dailyLimit = plan.getDailyLimit(date);
    return entry.amount <= dailyLimit;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_planInfo == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('플랜 데이터를 불러올 수 없습니다.')),
      );
    }

    final plan = _planInfo!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Text(
              FirebaseAuth.instance.currentUser?.displayName ?? '유저',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.settings, color: Colors.black),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          MainGraph(
              planInfo: plan,
              state: dailyState, // state => 하단의 금일 사용 금액에 따라 달라지는...
          ),
          const SizedBox(height: 16),
          // 일일 지출 카드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).pushNamed(
                  '/spend_list',
                  arguments: dateEntry,
                );
                await loadDateEntry(searchDate);
                await loadWeekAmount(searchDate, startDate: plan.startDate, endDate: plan.endDate);
              },
              child: Card(
                color: dailyState ? Color(0xFFEFF5FF) : Color(0xFFFFEFEF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatToKoreanDate(searchDate),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: dateEntry.dateEntry.isEmpty
                                      ? '0원'
                                      : '${dateEntry!.amount.toStringAsFixed(0).replaceAllMapped(
                                      RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}원',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: dailyState ? Color(0xFF0062FF) : Color(0xFFFF5F5F)),
                                ),
                                TextSpan(
                                  text: '/${(plan.getDailyLimit(dateEntry.date!) -
                                      (refData != null
                                          ? refData!.getInstallmentConsumptionAmount(dateEntry.date!, plan.effectiveEndDate!)
                                          : 0) +
                                      (refData != null
                                      ? refData!.getInstallmentIncomeAmount(dateEntry.date!, plan.effectiveEndDate!)
                                      : 0)).toString().replaceAllMapped(
                                      RegExp(r'\B(?=(\d{3})+(?!\d))'),
                                          (match) => ',')}원',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton( // 일일 소비
                            icon: Icon(Icons.chevron_left,
                                color: (plan.startDate != null && searchDate.isAfter(plan.startDate!))
                                    ? Colors.black
                                    : Colors.grey
                            ),
                            onPressed: () async { 
                              if(plan.startDate != null && searchDate.isAfter(plan.startDate!)) {
                                dayCount--;
                                searchDate = addDays(DateTime.now(), dayCount);
                                await loadDateEntry(searchDate);
                              }
                              }
                          ),
                          SizedBox(width: 8),
                          IconButton(
                              icon: Icon(Icons.chevron_right,
                                  color: (searchDate.isBefore(nowDate))
                                      ? Colors.black
                                      : Colors.grey
                              ),
                              onPressed: () async {
                                if(searchDate.isBefore(nowDate)) {
                                  dayCount++;
                                  searchDate = addDays(DateTime.now(), dayCount);
                                  await loadDateEntry(searchDate);
                                  // 0원
                                }
                              }
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Card(
              color: const Color(0xFFF4F4F4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (plan.startDate != null)
                              ? '${getWeekNumber(plan.startDate!, searchWeek)}주차 누적금액'
                              : '주차 정보 없음',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${weekAmount.toStringAsFixed(0).replaceAllMapped(
                            RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}원',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton( // 누적 금액 <=
                            icon: Icon(Icons.chevron_left,
                                color: (getPreviousWeekSunday(searchWeek).isAfter(plan.startDate!))
                                    ? Colors.black
                                    : Colors.grey
                            ),
                            onPressed: () async {
                              final prevWeek = getPreviousWeekSunday(searchWeek);

                              if (getPreviousWeekSunday(searchWeek).isAfter(plan.startDate!)) {
                                setState(() {
                                  searchWeek = prevWeek;
                                });
                                print('prev $searchWeek');
                                await loadWeekAmount(searchWeek, startDate: plan.startDate);
                              }
                            }
                        ),
                        SizedBox(width: 8),
                        IconButton( // 누적 금액 =>
                            icon: Icon(Icons.chevron_right,
                                color: (!getNextWeekSunday(searchWeek, nowDate).isAfter(nowDate) && searchWeek.isBefore(nowDate))
                                    ? Colors.black
                                    : Colors.grey
                            ),
                            onPressed: () async {
                              final nextWeek = getNextWeekSunday(searchWeek, nowDate);

                              if (!getNextWeekSunday(searchWeek, nowDate).isAfter(nowDate) && searchWeek.isBefore(nowDate)) {
                                setState(() {
                                  searchWeek = nextWeek; // inputDate
                                });
                                print('next $searchWeek');
                                await loadWeekAmount(searchWeek, endDate: plan.endDate); // inputDate & startDate
                              }
                            }
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.black,
        onTap: (index) {
          if (index == 0) {
            //Navigator.pushNamed(context, '/report'); // REPORT
          } else if (index == 1) {
            Navigator.pushNamed(context, '/');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/myPage'); // PROFILE
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: 'REPORT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }
}
