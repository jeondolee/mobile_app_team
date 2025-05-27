
class SignUpInfo {
  String email;
  String password;
  String name;
  String gender;
  String birthday;
  String profileImg;

  SignUpInfo({
    required this.email,
    required this.password,
    this.name = '',
    this.gender = '',
    this.birthday = '',
    this.profileImg = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': email,
      'pw': password,
      'name': name,
      'gender': gender,
      'birthday': birthday,
      'profileImg': profileImg,
    };
  }
}