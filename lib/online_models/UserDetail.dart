
class UserDetail {


  UserDetail({
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


  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
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

// String? userId;
// String? firstName;
// String? lastName;
// String? username;
// String? email;
// String? password;
// String? mobile;
// String? address;
// String? image;
// String? createdAt;
// String? updatedAt;
// String? isActive;
//
// UserDetail(
//     {this.userId,
//       this.firstName,
//       this.lastName,
//       this.username,
//       this.email,
//       this.password,
//       this.mobile,
//       this.address,
//       this.image,
//       this.createdAt,
//       this.updatedAt,
//       this.isActive});
//
// UserDetail.fromJson(Map<String, dynamic> json) {
//   userId = json['user_id'];
//   firstName = json['first_name'];
//   lastName = json['last_name'];
//   username = json['username'];
//   email = json['email'];
//   password = json['password'];
//   mobile = json['mobile'];
//   address = json['address'];
//   image = json['image'];
//   createdAt = json['created_at'];
//   updatedAt = json['updated_at'];
//   isActive = json['is_active'];
// }
//
// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['user_id'] = this.userId;
//   data['first_name'] = this.firstName;
//   data['last_name'] = this.lastName;
//   data['username'] = this.username;
//   data['email'] = this.email;
//   data['password'] = this.password;
//   data['mobile'] = this.mobile;
//   data['address'] = this.address;
//   data['image'] = this.image;
//   data['created_at'] = this.createdAt;
//   data['updated_at'] = this.updatedAt;
//   data['is_active'] = this.isActive;
//   return data;
// }
}

