class UserInfo {
  final String uid;
  final String avatar;
  final String nickname;
  final String email;
 /* final String telephone;*/

  UserInfo({this.uid, this.avatar, this.nickname, this.email});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      uid: json["uid"],
      avatar: json["avatar"],
      nickname: json["nickname"],
      email: json["email"],
      /*telephone: json["telephone"],*/
    );
  }

  Map toJson() {
    Map map = Map();
    map["uid"] = this.uid;
    map["avatar"] = this.avatar;
    map["nickname"] = this.nickname;
    map["email"] = this.email;
    return map;
  }
}