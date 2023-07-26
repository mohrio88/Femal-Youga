class ModeBodySpecificCategory {
  Data? data;

  ModeBodySpecificCategory({this.data});

  ModeBodySpecificCategory.fromJson(Map<String, dynamic> json) {
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
  List<BodySpecificCategory>? category;
  String? error;

  Data({this.success, this.category, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['category'] != null) {
      category = [];
      json['category'].forEach((v) {
        category!.add(BodySpecificCategory.fromJson(v));
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

class BodySpecificCategory {
  String? categoryId;
  String? category;
  String? image;
  String? totalWorkOuts;
  String? isActive;

  BodySpecificCategory(
      {this.categoryId,
      this.category,
      this.image,
      this.totalWorkOuts,
      this.isActive});

  BodySpecificCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'].toString();
    category = json['category'];
    image = json['image'];
    totalWorkOuts = json['total_workouts'].toString();
    isActive = json['is_active'].toString() ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category'] = category;
    data['image'] = image;
    data['total_workouts'] = totalWorkOuts;
    data['is_active'] = isActive;
    return data;
  }
}
