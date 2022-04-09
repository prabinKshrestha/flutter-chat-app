import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChatModel extends Equatable {
  final int id;
  final int fkConsultancyId;
  final String message;
  final String file;
  final String fileUrl;
  final bool isClient;
  final DateTime createdOn;

  ChatModel({
    @required this.id,
    @required this.fkConsultancyId,
    @required this.message,
    @required this.file,
    @required this.fileUrl,
    @required this.isClient,
    @required this.createdOn,
  });

  @override
  List<Object> get props => [];

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      fkConsultancyId: map['fkConsultancyId'],
      message: map['message'],
      file: map['file'],
      fileUrl: map['fileUrl'],
      isClient: map['isClient'],
      createdOn: map['createdOn'] != null ? DateTime.parse(map['createdOn']) : null,
    );
  }

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source));
}
