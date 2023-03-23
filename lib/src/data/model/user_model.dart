class UserModel {
  String? id;
  String? displayName;
  String? email;
  String? registerDate;

  UserModel({this.id, this.displayName, this.email, this.registerDate});

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      id: json['uid'] as String,
      displayName: json['display_name'] as String,
      email: json['email'] as String,
      registerDate: json['register_date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['display_name'] = displayName;
    data['email'] = email;
    data['register_date'] = registerDate;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'email': email,
      'display_name': displayName,
      'register_date': registerDate,
    };
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    email = map['email'];
    displayName = map['display_name'];
    registerDate = map['register_date'];
  }
}
