class RoomModel {
  String? uid;
  String? name;
  String? owner;
  String? buildingUid;

  RoomModel({this.uid, this.name, this.owner, this.buildingUid});

  factory RoomModel.fromJson(dynamic json) {
    return RoomModel(
      uid: json['id'] as String,
      name: json['name'] as String,
      owner: json['owner'] as String,
      buildingUid: json['buildingUid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = uid;
    data['name'] = name;
    data['owner'] = owner;
    data['buildingUid'] = buildingUid;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': uid,
      'name': name,
      'owner': owner,
      'buildingUid': buildingUid,
    };
    return map;
  }
}