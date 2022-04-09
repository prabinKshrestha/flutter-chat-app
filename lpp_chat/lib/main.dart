import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lpp_chat/app.dart';
import 'package:lpp_chat/datas/chats/chat_repository.dart';
import 'package:lpp_chat/datas/consultancy/consultancy_repository.dart';

void main() {
  final Dio _httpClient = Dio();
  runApp(
    App(
      consultancyRepository: ConsultancyRepository(consultancyAPIProvider: ConsultancyAPIProvider(httpClient: _httpClient)),
      chatRepository: ChatRepository(chatAPIProvider: ChatAPIProvider(httpClient: _httpClient)),
    ),
  );
}
