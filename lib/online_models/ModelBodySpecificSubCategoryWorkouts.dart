import 'package:flutter_yoga_workout_4_all_new/online_models/ModelOtherWorkoutCategoryList.dart';

class ModelBodySpecificSubCategoryWorkouts {
  Data? data;

  ModelBodySpecificSubCategoryWorkouts({this.data});

  ModelBodySpecificSubCategoryWorkouts.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? success;
  List<ModelOtherWorkoutCategoryWorkout>? workouts;
  String? error;

  Data({this.success, this.workouts, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['workouts'] != null) {
      workouts = [];
      json['workouts'].forEach((v) {
        workouts!.add(ModelOtherWorkoutCategoryWorkout.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (workouts != null) {
      data['workouts'] = workouts!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    return data;
  }
}


