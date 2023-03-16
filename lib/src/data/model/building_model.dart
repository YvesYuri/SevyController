class BuildingModel {
  String? uid;
  String? name;
  String? cover;
  String? owner;

  BuildingModel({this.uid, this.name, this.cover, this.owner});

  factory BuildingModel.fromJson(dynamic json) {
    return BuildingModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      cover: json['cover'] as String,
      owner: json['owner'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['cover'] = cover;
    data['owner'] = owner;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'uid': uid,
      'name': name,
      'cover': cover,
      'owner' : owner,
    };
    return map;
  }

  BuildingModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    cover = map['cover'];
    owner = map['owner'];
  }
}
