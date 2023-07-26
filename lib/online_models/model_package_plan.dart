import 'dart:convert';

ModelPackagePlan modelPackagePlanFromJson(String str) => ModelPackagePlan.fromJson(json.decode(str));

String modelPackagePlanToJson(ModelPackagePlan data) => json.encode(data.toJson());

class ModelPackagePlan {
  ModelPackagePlan({
    this.data,
  });

  PlanData? data;

  factory ModelPackagePlan.fromJson(Map<String, dynamic> json) => ModelPackagePlan(
    data: json["data"] == null ? null : PlanData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data!.toJson(),
  };
}

class PlanData {
  PlanData({
    this.success,
    this.packageplan,
    this.isPro,
    this.planId,
    this.error,
  });

  int? success;
  List<Packageplan>? packageplan;
  String? error;
  String? isPro;
  String? planId;

  factory PlanData.fromJson(Map<String, dynamic> json) => PlanData(
    success: json["success"] == null ? null : json["success"],
    packageplan: json["plan"] == null ? null : List<Packageplan>.from(json["plan"].map((x) => Packageplan.fromJson(x))),
    isPro: json["isPro"] == null? "0":json["isPro"].toString(),
    planId: json["plan_id"] == null? "0":json["plan_id"].toString(),
    error: json["error"] == null ? null : json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "plan": packageplan == null ? null : List<dynamic>.from(packageplan!.map((x) => x.toJson())),
    "isPro": isPro,
    "error": error == null ? null : error,
  };
}

class Packageplan {
  Packageplan({
    this.planId,
    this.planName,
    this.price,
    this.months,
    this.days,
    this.is_active,
    this.skuIdAndroid,
    this.skuIdIOS,
  });

  String? planId;
  String? planName;
  String? price;
  String? months;
  String? days;
  String? is_active;
  String? skuIdAndroid;
  String? skuIdIOS;

  factory Packageplan.fromJson(Map<String, dynamic> json) => Packageplan(
    skuIdAndroid: json["sku_id_android"] == null ? null : json["sku_id_android"],
    skuIdIOS: json["sku_id_ios"] == null ? null : json["sku_id_ios"],
    is_active: json["is_active"] == null ? null : json["is_active"].toString(),
    planId: json["plan_id"] == null ? null : json["plan_id"].toString(),
    planName: json["plan_name"] == null ? null : json["plan_name"],
    price: json["price"] == null ? null : json["price"].toString(),
    months: json["months"] == null ? null : json["months"].toString(),
    days: json["days"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "sku_id_android": skuIdAndroid == null ? null : skuIdAndroid,
    "sku_id_ios": skuIdIOS == null ? null : skuIdIOS,
    "is_active": is_active == null ? null : is_active,
    "plan_id": planId == null ? null : planId,
    "plan_name": planName == null ? null : planName,
    "price": price == null ? null : price,
    "months": months == null ? null : months,
    "days": days,
  };
}

// class PackageplanPoint {
//   PackageplanPoint({
//     this.planPointId,
//     this.point,
//   });
//
//   String? planPointId;
//   String? point;
//
//   factory PackageplanPoint.fromJson(Map<String, dynamic> json) => PackageplanPoint(
//     planPointId: json["plan_point_id"] == null ? null : json["plan_point_id"],
//     point: json["point"] == null ? null : json["point"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "plan_point_id": planPointId == null ? null : planPointId,
//     "point": point == null ? null : point,
//   };
// }
