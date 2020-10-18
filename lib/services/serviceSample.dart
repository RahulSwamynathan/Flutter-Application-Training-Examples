import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class SampleService extends http.BaseClient {
  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      return await _client.send(request);
    } on Exception catch (ex) {
      print(ex);
      throw ex;
    }
  }

  Future<http.Response> sendRequest(http.BaseRequest request) async {
    return http.Response.fromStream(await send(request));
  }

  String readData(http.Response response) {
    try {
      if (response.statusCode == 200) {
        return response.body;
      }
      throw Exception("No data");
    } on Exception catch (ex) {
      throw ex;
    }
  }
}

class APIService extends SampleService {
  Future<String> getValues() async {
    try {
      final request = http.Request("GET", Uri.parse("https://jsonplaceholder.typicode.com/albums/1"));
      http.Response response = await sendRequest(request);
      return readData(response);
    } on Exception catch (ex) {
      throw ex;
    }
  }

  Future<String> getPlaceHolders() async {
    try {
      final response = await http.get("https://jsonplaceholder.typicode.com/albums/12");

      return readData(response);
    } on Exception catch (ex) {
      throw ex;
    }
  }

  Future<String> loadAsset() async {
    try {
      return await rootBundle.loadString('assets/json/values.json');
    } on Exception catch (ex) {
      throw ex;
    }
  }
}

//Use this link to create 'dart' class based on the 'json' object [https://javiercbk.github.io/json_to_dart/]
class UserInfo {
  int userId;
  int id;
  String title;

  UserInfo({this.userId, this.id, this.title});

  UserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
