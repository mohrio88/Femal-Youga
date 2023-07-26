import 'dart:convert';

ModelCheckPurchasePlanDay modelCheckPurchasePlanDayFromJson(String str) => ModelCheckPurchasePlanDay.fromJson(json.decode(str));

String modelCheckPurchasePlanDayToJson(ModelCheckPurchasePlanDay data) => json.encode(data.toJson());

class ModelCheckPurchasePlanDay {
  ModelCheckPurchasePlanDay({
    this.data,
  });

  Data? data;

  factory ModelCheckPurchasePlanDay.fromJson(Map<String, dynamic> json) => ModelCheckPurchasePlanDay(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.success,
    this.checkpurchaseplanday,
    this.error,
  });

  int? success;
  Checkpurchaseplanday? checkpurchaseplanday;
  String? error;

  factory Data.fromJson(Map<String, dynamic> json) {


    int i=json["success"] == null ? null : json["success"];

    return  i == 0?
    Data(
      success: i,
      error: json["error"] == null ? null : json["error"],
    )
        : Data(
      success: i,
      checkpurchaseplanday: json["checkpurchaseplanday"] == null ? null : Checkpurchaseplanday.fromJson(json["checkpurchaseplanday"]),
      error: json["error"] == null ? null : json["error"],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "checkpurchaseplanday": checkpurchaseplanday == null ? null : checkpurchaseplanday,
    "error": error == null ? null : error,
  };
}

class Checkpurchaseplanday {
  Checkpurchaseplanday({
    required this.isActive,
    required this.expireDay,
  });

  String isActive;
  int expireDay;

  factory Checkpurchaseplanday.fromJson(Map<String, dynamic> json) => Checkpurchaseplanday(
    isActive: json["is_active"].toString() ?? "0",
    expireDay: json["expire_day"]?? 0,
  );

  Map<String, dynamic> toJson() => {
    "is_active": isActive,
    "expire_day": expireDay,
  };
}