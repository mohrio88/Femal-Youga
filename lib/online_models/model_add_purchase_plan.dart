import 'dart:convert';

ModelAddPurchasePlan modelAddPurchasePlanFromJson(String str) => ModelAddPurchasePlan.fromJson(json.decode(str));

String modelAddPurchasePlanToJson(ModelAddPurchasePlan data) => json.encode(data.toJson());

class ModelAddPurchasePlan {
  ModelAddPurchasePlan({
    this.data,
  });

  Data? data;

  factory ModelAddPurchasePlan.fromJson(Map<String, dynamic> json) => ModelAddPurchasePlan(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.success,
    this.purchaseplan,
    this.error,
  });

  int? success;
  List<dynamic>? purchaseplan;
  String? error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"] == null ? null : json["success"],
    purchaseplan: json["purchaseplan"] == null ? null : List<dynamic>.from(json["purchaseplan"].map((x) => x)),
    error: json["error"] == null ? null : json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "purchaseplan": purchaseplan == null ? null : List<dynamic>.from(purchaseplan!.map((x) => x)),
    "error": error == null ? null : error,
  };
}
