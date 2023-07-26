// To parse this JSON data, do
//
//     final challengeWeekModel = challengeWeekModelFromJson(jsonString);

import 'dart:convert';

ChallengeWeekModel challengeWeekModelFromJson(String str) => ChallengeWeekModel.fromJson(json.decode(str));

String challengeWeekModelToJson(ChallengeWeekModel data) => json.encode(data.toJson());

class ChallengeWeekModel {
  ChallengeWeekModel({
    this.data,
  });

  Data? data;

  factory ChallengeWeekModel.fromJson(Map<String, dynamic> json) => ChallengeWeekModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.success,
    this.week,
    this.error,
  });

  int? success;
  List<Week>? week;
  String? error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    week: List<Week>.from(json["week"].map((x) => Week.fromJson(x))),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "week": List<dynamic>.from(week!.map((x) => x.toJson())),
    "error": error,
  };
}

class Week {
  Week({
    this.weekId,
    this.challengesId,
    this.weekName,
    this.totalDays,
    this.isCompleted,
  });

  String? weekId;
  String? challengesId;
  String? weekName;
  int? totalDays;
  int? isCompleted;

  factory Week.fromJson(Map<String, dynamic> json) => Week(
    weekId: json["week_id"].toString(),
    challengesId: json["challenges_id"].toString(),
    weekName: json["week_name"],
    totalDays: json["totaldays"],
    isCompleted: json["is_completed"],
  );

  Map<String, dynamic> toJson() => {
    "week_id": weekId,
    "challenges_id": challengesId,
    "week_name": weekName,
    "totaldays": totalDays,
    "is_completed": isCompleted,
  };
}
