import 'package:flutter/material.dart';
import '../../../models/plan_info.dart';
import '../../../models/refData.dart';

class ConsultRatioPage extends StatefulWidget {
  final PlanInfo planInfo;
  final RefData refData;

  const ConsultRatioPage({
    super.key,
    required this.planInfo,
    required this.refData,
  });

  @override
  State<ConsultRatioPage> createState() => _ConsultRatioPageState();
}

class _ConsultRatioPageState extends State<ConsultRatioPage> {
  Set<int> _selectedIndexes = {};

  final List<String> _icons = ['🔥', '🏃', '☕'];
  final List<String> _labels = ['강력하게', '적절하게', '부담없이'];
  final List<String> _times = ['70%', '50%', '25%'];
  final List<int> _rates = [70, 50, 25];

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndexes = {index}; // 하나만 선택 가능
    });
  }

  void _onNextPressed() {
    if (_selectedIndexes.isEmpty) return;

    final selectedRate = _rates[_selectedIndexes.first];
    widget.planInfo.savingRate = selectedRate;

    Navigator.of(context).pushNamed(
      '/consultPeriod',
      arguments: {
        'planInfo': widget.planInfo,
        'refData': widget.refData,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 50,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const Text(
                '절약 비율을 선택해주세요',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: screenHeight * 0.2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return GestureDetector(
                    onTap: () => _onButtonPressed(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedIndexes.contains(index)
                                  ? Colors.black
                                  : Colors.white,
                              border: Border.all(
                                color: _selectedIndexes.contains(index)
                                    ? Colors.black
                                    : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Center(
                                child: Text(
                                  _icons[index],
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: _selectedIndexes.contains(index)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            _labels[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _selectedIndexes.contains(index)
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            _times[index],
                            style: TextStyle(
                              fontSize: 14,
                              color: _selectedIndexes.contains(index)
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: screenHeight * 0.2),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedIndexes.isNotEmpty ? _onNextPressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedIndexes.isNotEmpty
                        ? const Color(0xFF007BFF)
                        : Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '소통 시작하기',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
