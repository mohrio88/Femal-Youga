class ModelDetailExerciseList {
  Data? data;

  ModelDetailExerciseList({this.data});

  ModelDetailExerciseList.fromJson(Map<String, dynamic> json) {
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
  List<Exercise>? exercise;
  String exercise_tools = "";
  String? error;

  Data({this.success, this.exercise, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    exercise = [];
    if (json['stretch'] != null) {
      json['stretch'].forEach((v) {
        exercise!.add(new Exercise.fromJson(v, true));
      });
    }
    if (json['exercise'] != null) {
      json['exercise'].forEach((v) {
        exercise!.add(new Exercise.fromJson(v, false));
      });
    }
    if(json['exercise_tools'] != null){
      exercise_tools = json['exercise_tools'];
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.exercise != null) {
      data['exercise'] =
          this.exercise!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    data['exercise_tools'] = this.exercise_tools;
    return data;
  }

}

class Exercise  {
  String? exerciseId;
  String? exerciseName;
  String? videoUrl;
  String? thumbnailUrl;
  String? hostVideoUrl;
  String? hostIconUrl;
  String? image;
  String? description;
  String? exerciseTime;
  bool? isStretch;

  Exercise (
      {this.exerciseId,
        this.exerciseName,
        this.image,
        this.description,
        this.exerciseTime});

  Exercise.fromJson(Map<String, dynamic> json, bool isStretch1) {
    print("json====${json['video']}=====${json.toString()}");
    exerciseId = json['exercise_id'].toString();
    exerciseName = json['exercise_name'];
    image = json['image'];
    description = json['description'];
    videoUrl = json['video']??'';
    thumbnailUrl = json['thumbnail']??'';
    exerciseTime = json['exercise_time'];
    hostVideoUrl = json['video_url']??'';
    hostIconUrl = json['icon_url']??'';
    isStretch = isStretch1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exercise_id'] = this.exerciseId;
    data['exercise_name'] = this.exerciseName;
    data['image'] = this.image;
    data['description'] = this.description;
    data['exercise_time'] = this.exerciseTime;
    data['video'] = this.videoUrl;
    data['icon_url'] = this.hostIconUrl;
    data['video_url'] = this.hostVideoUrl;
    return data;
  }
}
