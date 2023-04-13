class DeviceModel {
  String? id;
  String? name;
  String? owner;
  String? roomId;
  String? state;
  String? ssid;
  String? bssid;
  String? ip;
  String? model;
  String? serialNumber;

  DeviceModel({
    this.id,
    this.name,
    this.owner,
    this.roomId,
    this.state,
    this.ssid,
    this.bssid,
    this.ip,
    this.model,
    this.serialNumber,
  });

  factory DeviceModel.fromJson(dynamic json) {
    return DeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      owner: json['owner'] as String,
      roomId: json['room_id'] as String,
      state: json['state'] as String,
      ssid: json['ssid'] as String,
      bssid: json['bssid'] as String,
      ip: json['ip'] as String,
      model: json['model'] as String,
      serialNumber: json['serial_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['owner'] = owner;
    data['room_id'] = roomId;
    data['state'] = state;
    data['ssid'] = ssid;
    data['bssid'] = bssid;
    data['ip'] = ip;
    data['model'] = model;
    data['serial_number'] = serialNumber;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'owner': owner,
      'room_id': roomId,
      'state': state,
      'ssid': ssid,
      'bssid': bssid,
      'ip': ip,
      'model': model,
      'serial_number': serialNumber,
    };
    return map;
  }
}
