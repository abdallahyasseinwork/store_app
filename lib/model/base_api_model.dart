// To parse this JSON data, do
//
//     final baseApiModel = baseApiModelFromMap(jsonString);

import 'dart:convert';

BaseApiModel baseApiModelFromMap(String str) => BaseApiModel.fromMap(json.decode(str));

String baseApiModelToMap(BaseApiModel data) => json.encode(data.toMap());

class BaseApiModel {
    BaseApiModel({
        required this.id,
        required this.domain,
        required this.tenantId,
        required this.appId,
        required this.createdAt,
        required this.updatedAt,
    });

    int id;
    String domain;
    String tenantId;
    String appId;
    String createdAt;
    String updatedAt;

    factory BaseApiModel.fromMap(Map<String, dynamic> json) => BaseApiModel(
        id: json["id"],
        domain: json["domain"],
        tenantId: json["tenant_id"],
        appId: json["app_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "domain": domain,
        "tenant_id": tenantId,
        "app_id": appId,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
