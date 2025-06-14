import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/plan_info.dart';

class PieModel {
  final int count;
  final Color color;
  PieModel({required this.count, required this.color});
}

class MainGraph extends StatelessWidget {
  final PlanInfo planInfo;
  final bool state;

  const MainGraph({
    super.key,
    required this.planInfo,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // 색상 설정
    Color primaryColor = state ? Color(0xFF0062FF) : Color(0xFFFF5F5F);
    Color secondaryColor = state ? Color(0xFFC0D8FF) : Color(0xFFFFCFCF);
    Color innerPrimaryColor = state ? Color(0xFF00368C) : Color(0xFFBD2828);
    Color innerSecondaryColor = state ? Color(0xFFC0D8FF) : Color(0xFFFFCFCF);
    Color textColor = state ? Color(0xFF0062FF) : Color(0xFFFF5F5F);

    int dDay = planInfo.dDay;
    int goalAmount = planInfo.goalAmount;
    int dateProgress = calculateDateProgress(planInfo.startDate, planInfo.endDate, planInfo.now);
    int amountProgress = calculateAmountProgress(planInfo.goalAmount, planInfo.currentAmount);

    // 그래프 데이터 계산
    int outerRemaining = 100 - dateProgress;
    int innerRemaining = 100 - amountProgress;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: state ? Color(0xFFEFF5FF) : Color(0xFFFFEFEF), // 배경 색
      margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상단 제목과 D-Day 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'D-$dDay  ',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '목표 금액까지',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${goalAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}원',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 0),
            // 반원 그래프
            SizedBox(
              width: 250,
              height: 140,
              child: CustomPaint(
                painter: _DoubleHalfRadialChart(
                  [
                    PieModel(count: dateProgress, color: primaryColor),
                    PieModel(count: outerRemaining, color: secondaryColor),
                  ],
                  [
                    PieModel(count: amountProgress, color: innerPrimaryColor),
                    PieModel(count: innerRemaining, color: innerSecondaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 범례
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 5, backgroundColor: primaryColor),
                const SizedBox(width: 8),
                const Text('진행한 기간', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 16),
                CircleAvatar(radius: 5, backgroundColor: innerPrimaryColor),
                const SizedBox(width: 8),
                const Text('목표 달성까지', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int calculateDateProgress(DateTime? startDate, DateTime? endDate, DateTime? nowDate) {
    if (startDate == null || endDate == null || nowDate == null) return 0;
    if (nowDate.isBefore(startDate)) return 0;
    if (nowDate.isAfter(endDate)) return 100;

    final totalDuration = endDate.difference(startDate).inDays;
    final elapsed = nowDate.difference(startDate).inDays;

    return ((elapsed / totalDuration) * 100).clamp(0, 100).round();
  }

  int calculateAmountProgress(int goalAmount, int currentAmount) {
    if (goalAmount == 0) return 0;
    return ((currentAmount / goalAmount) * 100).clamp(0, 100).round();
  }

}

class _DoubleHalfRadialChart extends CustomPainter {
  final List<PieModel> outerData;
  final List<PieModel> innerData;

  _DoubleHalfRadialChart(this.outerData, this.innerData);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height);
    double outerRadius = size.width * 0.45;
    double innerRadius = size.width * 0.35;

    // 바깥 반원 (목표 진행률) - 덮어쓰기 방식
    double startAngle = 0;
    paint.strokeWidth = 20;

    // 큰 선 먼저 그리기
    paint.color = outerData[0].color;
    double firstSweepAngle = -math.pi * (outerData[0].count / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle,
      firstSweepAngle,
      false,
      paint,
    );

    // 작은 선 그리기
    startAngle += firstSweepAngle;
    paint.color = outerData[1].color;
    double secondSweepAngle = -math.pi * (outerData[1].count / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle,
      secondSweepAngle,
      false,
      paint,
    );

    // 다시 큰 선 덮어쓰기
    paint.color = outerData[0].color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      0,
      firstSweepAngle,
      false,
      paint,
    );

    // 안쪽 반원 (실제 진행률) - 덮어쓰기 방식
    startAngle = 0;
    paint.strokeWidth = 15;

    // 큰 선 먼저 그리기
    paint.color = innerData[0].color;
    double innerFirstSweepAngle = -math.pi * (innerData[0].count / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      startAngle,
      innerFirstSweepAngle,
      false,
      paint,
    );

    // 작은 선 그리기
    startAngle += innerFirstSweepAngle;
    paint.color = innerData[1].color;
    double innerSecondSweepAngle = -math.pi * (innerData[1].count / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      startAngle,
      innerSecondSweepAngle,
      false,
      paint,
    );

    // 다시 큰 선 덮어쓰기
    paint.color = innerData[0].color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      0,
      innerFirstSweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}