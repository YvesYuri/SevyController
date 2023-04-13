
class BuildingModel {
  String? id;
  String? name;
  String? cover;
  String? owner;

  BuildingModel({this.id, this.name, this.cover, this.owner});

  factory BuildingModel.fromJson(dynamic json) {
    return BuildingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      cover: json['cover'] as String,
      owner: json['owner'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    data['owner'] = owner;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'cover': cover,
      'owner' : owner,
    };
    return map;
  }

  BuildingModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    cover = map['cover'];
    owner = map['owner'];
  }
}
