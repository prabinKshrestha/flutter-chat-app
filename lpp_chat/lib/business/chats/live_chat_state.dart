part of 'live_chat_bloc.dart';

@immutable
abstract class LiveChatState {}

class LiveChatStateInitial extends LiveChatState {}

class LiveChatStateRecieveMessage extends LiveChatState {
  final ChatModel chat;

  LiveChatStateRecieveMessage({
    @required this.chat,
  });
}

class LiveChatStateReconnect extends LiveChatState {}
