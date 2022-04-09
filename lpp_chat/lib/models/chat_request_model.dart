import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChatRequestModel extends Equatable {
  final int fkConsultancyId;
  final String message;
  final bool isClient;
  final File chatFile;

  ChatRequestModel({
    @required this.fkConsultancyId,
    @required this.message,
    @required this.isClient,
    @required this.chatFile,
  });

  @override
  List<Object> get props => [];

  Future<Map<String, dynamic>> toMapAsync() async {
    return {
      'fkConsultancyId': fkConsultancyId,
      'message': message,
      'isClient': isClient,
      'chatFile': chatFile != null ? await MultipartFile.fromFile(chatFile.path) : null,
    };
  }

  ChatRequestModel copyWith({
    int fkConsultancyId,
    String message,
    bool isClient,
    File chatFile,
  }) {
    return ChatRequestModel(
      fkConsultancyId: fkConsultancyId ?? this.fkConsultancyId,
      message: message ?? this.message,
      isClient: isClient ?? this.isClient,
      chatFile: chatFile,
    );
  }
}
