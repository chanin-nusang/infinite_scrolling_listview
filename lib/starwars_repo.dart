import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class People {
  String? name;
  int? height;
  int? mass;
  String? birthYear;
  String? gender;
  String? homeworld;
  String? hairColor;
  String? skinColor;
  String? eyeColor;
  int? no;

  People(
      {@required this.name,
      @required this.height,
      @required this.mass,
      @required this.birthYear,
      @required this.gender,
      @required this.homeworld,
      @required this.hairColor,
      @required this.skinColor,
      @required this.eyeColor,
      @required this.no});

  factory People.fromJson(Map<String, dynamic> json) => People(
        name: json["name"],
        height: int.parse(json["height"]),
        mass: int.parse(json["mass"]),
        hairColor: json["hair_color"],
        skinColor: json["skin_color"],
        eyeColor: json["eye_color"],
        birthYear: json["birth_year"],
        gender: json["gender"],
        homeworld: json["homeworld"],
        no: int.parse(json["url"]
            .toString()
            .substring(29, json["url"].toString().length - 1)),
      );
}

class Page {
  String? next;
  List<People>? people;
}

class StarwarsRepo {
  Future<List<People>> getPage(int pageNum) async {
    final url = 'swapi.dev';
    List<People>? page;
    var dio = Dio();
    final response = await dio
        .get('https://swapi.dev/api/people/?page=$pageNum&format=json');
    //var temp = utf8.decode(response.data.);
    //Map<String, dynamic> js = response.data['results']; //jsonDecode(temp)["results"];
    page = List<People>.from(
        response.data['results'].map((x) => People.fromJson(x)));
    return page;
  }
}
