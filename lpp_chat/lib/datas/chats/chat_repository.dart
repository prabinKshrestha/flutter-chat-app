import 'package:flutter/material.dart';
import 'package:lpp_chat/models/chat_model.dart';
import 'package:lpp_chat/models/chat_request_model.dart';

import '../base_api_provider.dart';

part 'chat_api_provider.dart';

class ChatRepository {
  final ChatAPIProvider chatAPIProvider;

  ChatRepository({@required this.chatAPIProvider});

  Future<List<ChatModel>> getChatsByConsultancyId(int consultancyId) async {
    return (await chatAPIProvider.getChatsByConsultancyId(consultancyId)).map((e) => ChatModel.fromMap(e)).toList();
  }

  Future<void> sendMessage(ChatRequestModel data) async {
    await chatAPIProvider.sendMessage(await data.toMapAsync());
  }
}
