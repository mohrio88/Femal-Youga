class ModelDiscover {
  Data? data;

  ModelDiscover({this.data});

  ModelDiscover.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? success;
  List<Discover>? discover;
  String? error;

  Data({this.success, this.discover, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['discover'] != null) {
      discover = [];
      json['discover'].forEach((v) {
        discover!.add(new Discover.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.discover != null) {
      data['discover'] = this.discover!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    return data;
  }
}

class Discover {
  String? discoverId;
  String? discover;
  String? image;
  String? description;
  String? isActive;

  Discover(
      {this.discoverId,
      this.discover,
      this.image,
      this.description,
      this.isActive});

  Discover.fromJson(Map<String, dynamic> json) {
    discoverId = json['discover_id'].toString();
    discover = json['discover'];
    image = json['image'];
    description = json['description'];
    isActive = json["is_active"].toString()?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discover_id'] = this.discoverId;
    data['discover'] = this.discover;
    data['image'] = this.image;
    data['description'] = this.description;
    data["is_active"] = this.isActive;
    return data;
  }
}
