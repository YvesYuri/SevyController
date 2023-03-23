class RoomModel {
  String? id;
  String? name;
  String? owner;
  String? buildingUid;

  RoomModel({this.id, this.name, this.owner, this.buildingUid});

  factory RoomModel.fromJson(dynamic json) {
    return RoomModel(
      id: json['id'] as String,
      name: json['name'] as String,
      owner: json['owner'] as String,
      buildingUid: json['building_uid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['owner'] = owner;
    data['building_uid'] = buildingUid;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'owner': owner,
      'building_uid': buildingUid,
    };
    return map;
  }
}