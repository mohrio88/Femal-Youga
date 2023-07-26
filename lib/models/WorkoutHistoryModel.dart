// To parse this JSON data, do
//
//     final workoutHistoryModel = workoutHistoryModelFromJson(jsonString);

import 'dart:convert';

WorkoutHistoryModel workoutHistoryModelFromJson(String str) => WorkoutHistoryModel.fromJson(json.decode(str));

String workoutHistoryModelToJson(WorkoutHistoryModel data) => json.encode(data.toJson());

class WorkoutHistoryModel {
  WorkoutHistoryModel({
    this.data,
  });

  Data? data;

  factory WorkoutHistoryModel.fromJson(Map<String, dynamic> json) => WorkoutHistoryModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.success,
    this.completedworkout,
    this.error,
  });

  int? success;
  List<CompletedHistoryworkout>? completedworkout;
  String? error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    completedworkout: List<CompletedHistoryworkout>.from(json["workoutcompleted"].map((x) => CompletedHistoryworkout.fromJson(x))),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "completedworkout": List<dynamic>.from(completedworkout!.map((x) => x.toJson())),
    "error": error,
  };
}

class CompletedHistoryworkout {
  CompletedHistoryworkout({
    this.workoutHistoryId,
    this.workoutType,
    this.workoutId,
    this.workoutDate,
    this.workoutTime,
    this.kcal,
  });

  String? workoutHistoryId;
  String? workoutType;
  String? workoutId;
  String? workoutDate;
  String? workoutTime;
  String? kcal;

  factory CompletedHistoryworkout.fromJson(Map<String, dynamic> json) => CompletedHistoryworkout(
    workoutHistoryId: json["workouts_completed_id"].toString(),
    workoutType: json["workout_type"].toString(),
    workoutId: json["workout_id"].toString(),
    workoutDate: (json["completed_date"]),
    workoutTime: json["completed_duration"].toString(),
    kcal: json["kcal"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "workouts_completed_id": workoutHistoryId,
    "workout_type": workoutType,
    "workout_id": workoutId,
    "completed_date": workoutDate,
    "completed_duration": workoutTime,
    "kcal": kcal,
  };
}
