import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/plan_info.dart';
import '../../../models/refData.dart';

class PlanGuidePage extends StatefulWidget {
  final PlanInfo planInfo;
  final RefData refData;

  const PlanGuidePage({
    super.key,
    required this.planInfo,
    required this.refData,
  });

  @override
  State<PlanGuidePage> createState() => _PlanGuidePageState();
}

class _PlanGuidePageState extends State<PlanGuidePage> {
  Future<String> _getUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? '사용자';
  }

  @override
  Widget build(BuildContext context) {
    // 임시 하드코딩 값
    final durationMonths = widget.planInfo.planDurationInMonths;
    final savingRate = widget.planInfo.savingRate;
    final monthlyLimit = widget.planInfo.monthlyLimit;
    final formatter = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: FutureBuilder<String>(
            future: _getUsername(),
            builder: (context, snapshot) {
              final userName = snapshot.data ?? '...';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w800, //ExtraBold
                      ),
                      children: [
                        TextSpan(text: '$userName님은 '),
                        TextSpan(
                          text: '$durationMonths개월',
                          style: TextStyle(
                            color: Color(0xFF0062FF),
                          ),
                        ),
                        TextSpan(
                          text: '동안\n',
                        ),
                        TextSpan(
                          text: '$savingRate%의 ',
                          style: TextStyle(
                            color: Color(0xFF0062FF),
                          ),
                        ),
                        TextSpan(
                          text: '절약비율로\n생활하시게 될 거예요.',
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF4FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(text: '입력하신 고정 수입과 소비,\n절약비율과 기간을 토대로\n변동소비 한달 금액이 한 달\n'),
                              TextSpan(
                                text: '${formatter.format(monthlyLimit)}원',
                                style: TextStyle(
                                    color: Color(0xFF0062FF),
                                    fontWeight: FontWeight.bold
                                ),),
                              TextSpan(text: '으로 설정되었어요.'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          child: Image.asset(
                            'sotong_svg/variable1.png',
                            fit: BoxFit.contain,
                          ),
                        ),

                      ],
                    ),
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(text: '소통은 여러분의 '),
                        TextSpan(
                          text: '\'변동소비\' 관리',
                          style: TextStyle(
                              color: Color(0xFF0062FF),
                              fontWeight: FontWeight.bold
                          ),),
                        TextSpan(text: '를\n도와드립니다.\n\n'),
                        TextSpan(text: '이 안에서 예산을 꾸려 볼까요?'),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/variableExpense',
                          arguments: {
                            'planInfo': widget.planInfo,
                            'refData': widget.refData,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0062FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('네, 진행해주세요!', style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        fontWeight: FontWeight.bold, //ExtraBold
                      ),),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}