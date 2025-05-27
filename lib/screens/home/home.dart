import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 393,
          height: 852,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 393,
                  height: 852,
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 41,
                top: 168,
                child: Container(
                  width: 311,
                  height: 118,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF4F4F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 9,
                top: 0,
                child: Container(
                  width: 375,
                  height: 44,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                            width: 375, height: 30, child: Stack()),
                      ),
                      Positioned(
                        left: 292,
                        top: 16,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 4,
                          children: [
                            Container(width: 20, height: 14, child: Stack()),
                            Container(width: 16, height: 14, child: Stack()),
                            Container(
                              width: 25,
                              height: 14,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 2,
                                    top: 3,
                                    child: Container(
                                      width: 19,
                                      height: 8,
                                      decoration: ShapeDecoration(
                                        color: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                1)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 298,
                        top: 8,
                        child: Container(width: 6, height: 6, child: Stack()),
                      ),
                      Positioned(
                        left: 21,
                        top: 12,
                        child: Container(
                          width: 54,
                          height: 21,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 11,
                                top: 3,
                                child: Container(
                                    width: 33, height: 15, child: Stack()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 66,
                child: IconButton(
                  icon: Icon(Icons.logout, color: Colors.black),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ),
              Positioned(
                left: 71,
                top: 194,
                child: Text(
                  '1월 16일',
                  style: TextStyle(
                    color: const Color(0xFF231E1E),
                    fontSize: 20,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
              ),
              Positioned(
                left: 71,
                top: 238,
                child: Text(
                  '아직 소비를 입력하지 않으셨어요!',
                  style: TextStyle(
                    color: const Color(0xFF858585),
                    fontSize: 16,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
              ),
              Positioned(
                left: 162,
                top: 489,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '남은 금액\n',
                        style: TextStyle(
                          color: const Color(0xFF231F1F),
                          fontSize: 18,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1,
                        ),
                      ),
                      TextSpan(
                        text: '345,000원',
                        style: TextStyle(
                          color: const Color(0xFF0062FF),
                          fontSize: 18,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                left: 0,
                top: 736,
                child: Container(
                  width: 393,
                  height: 116,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 9,
                top: 818,
                child: Container(
                  width: 375,
                  height: 34,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 120,
                        top: 21,
                        child: Container(
                          width: 134,
                          height: 5,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 134,
                                  height: 5,
                                  decoration: ShapeDecoration(
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 43,
                top: 117,
                child: Container(
                  width: 91,
                  height: 37,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF0062FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 74,
                top: 126,
                child: SizedBox(
                  width: 37,
                  child: Text(
                    '일간',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 146,
                top: 117,
                child: Container(
                  width: 91,
                  height: 37,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF4F4F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 177,
                top: 126,
                child: SizedBox(
                  width: 37,
                  child: Text(
                    '주간',
                    style: TextStyle(
                      color: const Color(0xFF9D9D9D),
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 43,
                top: 66,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '김유저',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w800,
                          letterSpacing: -2,
                        ),
                      ),
                      TextSpan(
                        text: ' 님',
                        style: TextStyle(
                          color: const Color(0xFF231E1E),
                          fontSize: 24,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w800,
                          letterSpacing: -2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 171,
                top: 450,
                child: Text(
                  'D-27',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF0062FF),
                    fontSize: 28,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
              ),
              Positioned(
                left: 327,
                top: 70,
                child: Container(
                  width: 25,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 59,
                top: 347,
                child: Container(
                  width: 287,
                  height: 287,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF0F0F0),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 346,
                top: 634,
                child: Container(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(3.14),
                  width: 287,
                  height: 287,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF0062FF),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 92,
                top: 380,
                child: Container(
                  width: 221,
                  height: 221,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF0F0F0),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 313,
                top: 601,
                child: Container(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(3.14),
                  width: 221,
                  height: 221,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF7CAEFF),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 121,
                top: 670,
                child: Text(
                  '진행한 기간',
                  style: TextStyle(
                    color: const Color(0xFF0062FF),
                    fontSize: 16,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
              ),
              Positioned(
                left: 101,
                top: 672,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF0062FF),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 226,
                top: 670,
                child: Text(
                  '목표 달성까지',
                  style: TextStyle(
                    color: const Color(0xFF7DAFFF),
                    fontSize: 16,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
              ),
              Positioned(
                left: 206,
                top: 672,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF7DAFFF),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 234,
                top: 179,
                child: Container(
                  width: 45,
                  height: 48,
                  decoration: BoxDecoration(color: const Color(0x00D9D9D9)),
                ),
              ),
              Positioned(
                left: 279,
                top: 253,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF0062FF),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 296,
                top: 261,
                child: Text(
                  '+',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 736,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 131,
                      height: 79,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 47, vertical: 15),
                      decoration: BoxDecoration(color: const Color(0x00D9D9D9)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Container(
                            width: 36,
                            height: 49,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 3,
                                  top: 0,
                                  child: Container(
                                    width: 29.63,
                                    height: 27,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: Stack(),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 35,
                                  child: Text(
                                    'HOME',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF535353),
                                      fontSize: 12,
                                      fontFamily: 'Pretendard Variable',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 131,
                      height: 79,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 131,
                              height: 79,
                              decoration: BoxDecoration(
                                  color: const Color(0x00D9D9D9)),
                            ),
                          ),
                          Positioned(
                            left: 42,
                            top: 16,
                            child: Container(
                              width: 47,
                              height: 48,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 8,
                                    top: 0,
                                    child: Container(
                                      width: 30,
                                      height: 28.46,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 34,
                                    child: Text(
                                      'REPORT',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFFC1C1C1),
                                        fontSize: 12,
                                        fontFamily: 'Pretendard Variable',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 131,
                      height: 79,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 131,
                              height: 79,
                              decoration: BoxDecoration(
                                  color: const Color(0x00D9D9D9)),
                            ),
                          ),
                          Positioned(
                            left: 42,
                            top: 15,
                            child: Container(
                              width: 48,
                              height: 50,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 9,
                                    top: 0,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 36,
                                    child: Text(
                                      'PROFILE',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFFC1C1C1),
                                        fontSize: 12,
                                        fontFamily: 'Pretendard Variable',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
