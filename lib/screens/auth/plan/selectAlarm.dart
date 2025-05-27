import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/setting.dart';

class SelectAlarmPage extends StatefulWidget {
  const SelectAlarmPage({super.key});

  @override
  State<SelectAlarmPage> createState() => _SelectAlarmPageState();
}

class _SelectAlarmPageState extends State<SelectAlarmPage> {
  // 여러 개 선택 가능하도록 Set으로 변경
  Set<int> _selectedIndexes = {};
  bool _isLoading = false;

  // 아이콘과 라벨, 시간 리스트
  final List<String> _icons = ['☀️', '🌼', '🌙'];
  final List<String> _labels = ['아침', '점심', '저녁'];
  final List<String> _times = ['9:00', '12:00', '17:00'];

  // 버튼 클릭 이벤트
  void _onButtonPressed(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  // Firestore에 알람 시간을 저장하는 메서드
  Future<void> _saveAlarmToFirestore(List<String> alarmTimes) async {
    setState(() {
      _isLoading = true;
    });

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      print('유저 ID 없음');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Setting 객체 생성
    Setting setting = Setting(alarmTimes: alarmTimes);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('setting')
          .set(setting.toMap(), SetOptions(merge: true));

      print('알람 시간이 저장되었습니다: $alarmTimes');

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      print('알람 저장 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const Text(
                '원활한 진행을 위해\n알림 주기를 선택해주세요',
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
              if (_isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _selectedIndexes.isNotEmpty
                        ? () {
                      List<String> selectedTimes = _selectedIndexes
                          .map((index) => _times[index])
                          .toList();
                      _saveAlarmToFirestore(selectedTimes);
                    }
                        : null,
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
