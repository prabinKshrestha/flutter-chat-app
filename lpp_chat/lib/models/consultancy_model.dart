import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ConsultancyModel extends Equatable {
  final int id;
  final String clientName;
  final String consultantName;
  final String text;
  final String file;
  final int rating;
  final String fileUrl;
  final DateTime creationDate;
  final DateTime closingDate;

  ConsultancyModel({
    @required this.id,
    this.clientName,
    this.consultantName,
    this.text,
    this.file,
    this.rating,
    this.fileUrl,
    this.creationDate,
    this.closingDate,
  });

  @override
  List<Object> get props => [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientName': clientName,
      'consultantName': consultantName,
      'text': text,
      'file': file,
      'rating': rating,
      'fileUrl': fileUrl,
      'creationDate': creationDate,
      'closingDate': closingDate,
    };
  }

  factory ConsultancyModel.fromMap(Map<String, dynamic> map) {
    return ConsultancyModel(
      id: map['id'],
      clientName: map['clientName'],
      consultantName: map['consultantName'],
      text: map['text'],
      file: map['file'],
      rating: map['rating'],
      fileUrl: map['fileUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsultancyModel.fromJson(String source) => ConsultancyModel.fromMap(json.decode(source));
}
