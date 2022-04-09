part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatEventInitial extends ChatEvent {}

class ChatEventRequest extends ChatEvent {
  final int consultancyId;

  ChatEventRequest(this.consultancyId);
}

class ChatEventAddRecieved extends ChatEvent {
  final List<ChatModel> chats;

  ChatEventAddRecieved(this.chats);
}

class ChatEventAddMessageRequest extends ChatEvent {
  final ChatRequestModel chat;

  ChatEventAddMessageRequest(this.chat);
}
