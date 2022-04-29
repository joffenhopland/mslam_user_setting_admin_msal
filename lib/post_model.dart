import 'dart:convert';


List<Post> postFromMap(String str) => List<Post>.from(json.decode(str).map((x) => Post.fromMap(x)));
String postToMap(List<Post> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Post {
  Post({
    required this.partitionKey,
    required this.rowKey,
    required this.userEmail,
    required this.deviceType,
    required this.settingKey,
    required this.settingValue,
  });

  String partitionKey;
  String rowKey;
  String userEmail;
  String deviceType;
  String settingKey;
  String settingValue;

  factory Post.fromMap(Map<String, dynamic> json) => Post(
    partitionKey: json["PartitionKey"],
    rowKey: json["RowKey"],
    userEmail: json["userEmail"],
    deviceType: json["deviceType"],
    settingKey: json["settingKey"],
    settingValue: json["settingValue"],
  );

  Map<String, dynamic> toMap() => {
    "PartitionKey": partitionKey,
    "RowKey": rowKey,
    "userEmail": userEmail,
    "deviceType": deviceType,
    "settingKey": settingKey,
    "settingValue": settingValue,
  };
}
/*

List<Post> postFromMap(String str) => List<Post>.from(json.decode(str).map((x) => Post.fromMap(x)));

String postToMap(List<Post> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Post {
  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  int userId;
  int id;
  String title;
  String body;

  factory Post.fromMap(Map<String, dynamic> json) => Post(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "id": id,
    "title": title,
    "body": body,
  };
}
*/
