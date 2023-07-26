// To parse this JSON data, do
//
//     final editProfileModel = editProfileModelFromJson(jsonString);

import 'dart:convert';

EditProfileModel editProfileModelFromJson(String str) => EditProfileModel.fromJson(json.decode(str));

String editProfileModelToJson(EditProfileModel data) => json.encode(data.toJson());

class EditProfileModel {
  EditProfileModel({
    this.data,
  });

  Data? data;

  factory EditProfileModel.fromJson(Map<String, dynamic> json) => EditProfileModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.success,
    this.editProfile,
    this.error,
  });

  int? success;
  EditProfile? editProfile;
  String? error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    editProfile: EditProfile.fromJson(json["editprofile"]),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "editprofile": editProfile!.toJson(),
    "error": error,
  };
}

class EditProfile {
  EditProfile({
    this.userId,
    this.firstName,
    this.username,
    this.email,
    this.password,
    this.age,
    this.height,
    this.weight,
    this.image,
    this.country,
    this.intensively,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.areas,
    this.loginType,
    this.desiredWeight,
  });

  String? userId;
  String? firstName;
  String? username;
  String? email;
  String? password;
  String? age;
  String? height;
  String? weight;
  String? desiredWeight;
  String? image;
  String? country;
  String? intensively;
  String? createdAt;
  String? updatedAt;
  String? isActive;
  String? areas;
  String? loginType; // 0: email, 1: google, 2: facebook, 3: apple
  String? socialId;

  factory EditProfile.fromJson(Map<String, dynamic> json) => EditProfile(
    userId: json["user_id"].toString(),
    firstName: json["first_name"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    age: json["age"],
    height: json["height"],
    weight: json["weight"],
    image: json["image"],
    country: json["country"],
    intensively: json["intensively"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    isActive: json["is_active"].toString()?? "0",
    areas: json["area"],
    loginType: json["login_type"].toString(),
    desiredWeight: json["desired_weight"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "first_name": firstName,
    "username": username,
    "email": email,
    "password": password,
    "age": age,
    "height": height,
    "weight": weight,
    "image": image,
    "country": country,
    "intensively": intensively,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_active": isActive,
    "area" : areas,
    "login_type":loginType,
    "desired_weight": desiredWeight,
  };
}
