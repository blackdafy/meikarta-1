// To parse this JSON data, do
//
//     final modelMenus = modelMenusFromJson(jsonString);

import 'dart:convert';

ModelMenus modelMenusFromJson(String str) =>
    ModelMenus.fromJson(json.decode(str));

String modelMenusToJson(ModelMenus data) => json.encode(data.toJson());

class ModelMenus {
  ModelMenus({
    this.menus,
  });

  List<Menu> menus;

  factory ModelMenus.fromJson(Map<String, dynamic> json) => ModelMenus(
        menus: json["menus"] == null
            ? null
            : List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "menus": menus == null
            ? null
            : List<dynamic>.from(menus.map((x) => x.toJson())),
      };
}

class Menu {
  Menu({
    this.appName,
    this.titleName,
    this.className,
    this.icons,
  });

  String appName;
  String titleName;
  String className;
  String icons;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        appName: json["app_name"] == null ? null : json["app_name"],
        titleName: json["title_name"] == null ? null : json["title_name"],
        className: json["class_name"] == null ? null : json["class_name"],
        icons: json["icons"] == null ? null : json["icons"],
      );

  Map<String, dynamic> toJson() => {
        "app_name": appName == null ? null : appName,
        "title_name": titleName == null ? null : titleName,
        "class_name": className == null ? null : className,
        "icons": icons == null ? null : icons,
      };
}
