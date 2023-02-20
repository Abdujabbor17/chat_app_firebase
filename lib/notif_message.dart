

import 'dart:convert';

class NotificationMessage{
  Data? data;
  NotificationMessage(this.data);

  NotificationMessage.fromJson(Map<String,dynamic> json){
    data = json['data'] !=null ? Data.fromJson(jsonDecode(json['data'])): null;
  }


}

class Data {
  String? title;
  String? message;

  Data(this.title, this.message);

  // From Json constructor
  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
  }

  // To Json method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['message'] = this.message;
    return data;
  }
}
