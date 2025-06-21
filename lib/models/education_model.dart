import 'package:flutter/material.dart';

class CertTypeModel {
  final int id;
  final String certificationName;
  final String name;

  CertTypeModel({
    required this.id,
    required this.certificationName,
    required this.name,

  });
  factory CertTypeModel.fromJson(Map<String, dynamic> json) {

    return CertTypeModel(
    id: json['id'],
    certificationName: json['certification']['name'],
    name: json['name'],
    );
  }
}

class Certificate {
  String name;
  List<Subject> subjects;

  IconData icon;
  String imageAsset;

  Certificate({
    required this.name,
    required this.subjects,
    required this.icon,
    required this.imageAsset,
  });
}

class Subject {
  String name;
  int maxMark;

  Subject({required this.name, required this.maxMark});
}
