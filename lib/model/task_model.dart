// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  final String owner;
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String endTime;
  final int remind;
  final String repeat;
  final String color;
  final String status;
  final List<String> collaboration;

  Task({
    required this.owner,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.remind,
    required this.repeat,
    required this.color,
    required this.status,
    required this.collaboration,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        owner: json["owner"],
        title: json["title"],
        description: json["description"],
        date: json["date"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        remind: json["remind"],
        repeat: json["repeat"],
        color: json["color"],
        status: json["status"],
        collaboration: List<String>.from(json["collaboration"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "owner": owner,
        "title": title,
        "description": description,
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "remind": remind,
        "repeat": repeat,
        "color": color,
        "status": status,
        "collaboration": List<dynamic>.from(collaboration.map((x) => x)),
      };
}
