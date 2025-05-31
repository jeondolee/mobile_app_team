import 'package:cloud_firestore/cloud_firestore.dart';

class Setting { // 무엇이 필요할까?
  List<String> alarmTimes;

  Setting({
    required List<String>? alarmTimes,
  })  : alarmTimes = alarmTimes ?? [];

  // Firestore에 저장하기 위한 Map 변환
  Map<String, dynamic> toMap() {
    return {
      'alarmTimes': alarmTimes,
    };
  }

  // Firestore에서 가져온 Map을 Setting 객체로 변환
  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      alarmTimes: List<String>.from(map['alarmTimes'] ?? []),
    );
  }

  /*
  // Firestore에 데이터 저장
  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance
        .collection('settings')
        .doc(settingName)
        .set(toMap());
  }


  // Firestore에서 데이터 불러오기
  static Future<Setting?> loadFromFirestore(String settingName) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('settings')
        .doc(settingName)
        .get();
    if (doc.exists) {
      return Setting.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
   */
}
