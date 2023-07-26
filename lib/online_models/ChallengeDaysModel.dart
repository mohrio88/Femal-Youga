class ChallengeDaysModel {
  Data? data;

  ChallengeDaysModel({this.data});

  ChallengeDaysModel.fromJson(Map<String, dynamic> json) {
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
  List<Days>? days;
  String? error;

  Data({this.success, this.days, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['days'] != null) {
      days =[];
      json['days'].forEach((v) {
        days!.add(new Days.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.days != null) {
      data['days'] = this.days!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    return data;
  }
}

class Days {
  String? daysId;
  String? weekId;
  String? daysName;
  int? is_completed;

  String? image;
  String? isPro;
  String? totalSecs;
  String? totalKcal;
  String? description;

  Days({this.daysId, this.weekId, this.daysName,this.is_completed});

  Days.fromJson(Map<String, dynamic> json) {
    daysId = json['days_id'].toString();
    weekId = json['week_id'].toString();
    daysName = json['days_name'].toString();
    is_completed = json['is_completed'];

    image = json['image'];
    isPro = json['is_pro'].toString();
    totalSecs = json['total_minutes'].toString();
    totalKcal = json['kcal'].toString();
    description = json['description']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['days_id'] = this.daysId;
    data['week_id'] = this.weekId;
    data['days_name'] = this.daysName;
    data['is_completed'] = this.is_completed;
    data['image'] = this.image;
    data['is_pro'] = this.isPro;
    data['total_minutes'] = this.totalSecs;
    data['kcal'] = this.totalKcal;
    data['description'] = this.description;

    return data;
  }
}
