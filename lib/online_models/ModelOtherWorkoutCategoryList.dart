class ModelOtherWorkoutCategoryList {
  Data? data;

  ModelOtherWorkoutCategoryList({this.data});

  ModelOtherWorkoutCategoryList.fromJson(Map<String, dynamic> json) {
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
  List<ModelOtherWorkoutCategory>? category;
  String? error;

  Data({this.success, this.category, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['category'] != null) {
      category = [];
      json['category'].forEach((v) {
        category!.add(ModelOtherWorkoutCategory.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    return data;
  }
}

class ModelOtherWorkoutCategory {
  String? categoryId;
  String? category;
  List<ModelOtherWorkoutCategoryWorkout>? workouts;
  String? isActive;

  ModelOtherWorkoutCategory(
      {this.categoryId,
      this.category,
      this.workouts,
      this.isActive});

  ModelOtherWorkoutCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'].toString();
    category = json['category'];
    isActive = json['is_active'].toString() ?? "0";
    if (json['workouts'] != null && json['workouts'] != false) {
      workouts = [];
      json['workouts'].forEach((v) {
        workouts!.add(ModelOtherWorkoutCategoryWorkout.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category'] = category;
    data['is_active'] = isActive;
    if (workouts != null) {
      data['workouts'] = workouts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModelOtherWorkoutCategoryWorkout {
  String? workoutId;
  String? workout;
  String? image;
  String? totalMinutes;
  String? kcal;
  String? description;
  String? isActive;

  ModelOtherWorkoutCategoryWorkout(
      {this.workoutId,
        this.workout,
        this.image,
        this.totalMinutes,
        this.isActive});

  ModelOtherWorkoutCategoryWorkout.fromJson(Map<String, dynamic> json) {
    workoutId = json['workout_id'].toString();
    workout = json['workout'];
    image = json['image'];
    description = json['description'];
    totalMinutes = json['total_minutes'].toString();
    kcal = json['kcal'].toString();
    isActive = json['is_active'].toString() ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workout_id'] = workoutId;
    data['workout'] = workout;
    data['image'] = image;
    data['description'] = description;
    data['total_minutes'] = totalMinutes;
    data['kcal'] = kcal;
    data['is_active'] = isActive;
    return data;
  }
}
