part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatStateInitial extends ChatState {}

class ChatStateFetchLoading extends ChatState {}

class ChatStateFetchSuccess extends ChatState {}

class ChatStateFetchError extends ChatState {}

class ChatStateDataCollection extends ChatState {
  final List<ChatModel> chats = [];

  ChatStateDataCollection(List<ChatModel> chat) {
    chats.addAll(chat);
  }
}

class ChatStateAddMessageLoading extends ChatState {}

class ChatStateAddMessageSuccess extends ChatState {}

class ChatStateAddMessageError extends ChatState {}
