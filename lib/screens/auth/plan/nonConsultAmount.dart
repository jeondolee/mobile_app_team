import 'package:flutter/material.dart';
import 'nonConsultDuration.dart';

class NonconsultAmountPage extends StatefulWidget {
  const NonconsultAmountPage({Key? key}) : super(key: key);

  @override
  _NonconsultAmountPageState createState() => _NonconsultAmountPageState();
}

class _NonconsultAmountPageState extends State<NonconsultAmountPage> {
  final TextEditingController _priceController = TextEditingController();
  bool _isInputValid = false;

  @override
  void initState() {
    super.initState();
    _priceController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      final input = _priceController.text.trim().replaceAll(',', '');
      _isInputValid = RegExp(r'^[0-9]+$').hasMatch(input);
    });
  }
  void _goToNextPage(BuildContext context) {
    String price = _priceController.text.trim();
    if (price.isNotEmpty) {
      print("설정한 금액: $price 원");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NonConsultDurationPage()),
      );
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Container(
                height: 44,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  '상태바',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            Positioned(
              left: 46,
              top: 129,
              child: Text(
                '목표 금액을 설정해주세요',
                style: TextStyle(
                  color: Color(0xFF231E1E),
                  fontSize: 28,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w800,
                  letterSpacing: -2,
                ),
              ),
            ),
            Positioned(
              left: 46,
              top: 221,
              child: Container(
                width: 294,
                height: 57,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'ex. 3,800,000',
                          hintStyle: TextStyle(
                            color: Color(0xFF909090),
                            fontSize: 17,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '원',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF231F1F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 49,
              top: 615, // 더 위로 조정
              child: Text(
                '조금만 기다려주세요',
                style: TextStyle(
                  color: Color(0xFF231F1F),
                  fontSize: 15,
                  fontFamily: 'Noto Sans',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -1,
                ),
              ),
            ),
            Positioned(
              left: 46,
              top: 680, // 버튼도 위로 이동
              child: GestureDetector(
                onTap: _isInputValid ? () => _goToNextPage(context) : null,
                child: Container(
                  width: 294,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _isInputValid ? Color(0xFF007BFF) : Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '다음',
                    style: TextStyle(
                      color: _isInputValid ? Colors.white : Color(0xFF9D9D9D),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 120,
              bottom: 10,
              child: Container(
                width: 134,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}