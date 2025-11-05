/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

Map<String, Datavn> datavnFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, Datavn>(k, Datavn.fromJson(v)));

String datavnToJson(Map<String, Datavn> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Datavn {
    Datavn({
        required this.pronunciation,
        required this.meaning,
        required this.type,
    });

    String pronunciation;
    String meaning;
    String type;

    factory Datavn.fromJson(Map<dynamic, dynamic> json) => Datavn(
        pronunciation: json["pronunciation"],
        meaning: json["meaning"],
        type: json["type"],
    );

    Map<dynamic, dynamic> toJson() => {
        "pronunciation": pronunciation,
        "meaning": meaning,
        "type": type,
    };
}
