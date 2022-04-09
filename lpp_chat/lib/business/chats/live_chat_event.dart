part of 'live_chat_bloc.dart';

@immutable
abstract class LiveChatEvent {}

class LiveChatEventInitial extends LiveChatEvent {}

class LiveChatEventConnectSignalR extends LiveChatEvent {}

class LiveChatEventReConnectSignalR extends LiveChatEvent {}

class LiveChatEventAddConnectionIdToGroup extends LiveChatEvent {
  final ConsultancyModel consultancy;

  LiveChatEventAddConnectionIdToGroup({
    @required this.consultancy,
  });
}

class LiveChatEventRemoveConnectionIdToGroup extends LiveChatEvent {
  final ConsultancyModel consultancy;

  LiveChatEventRemoveConnectionIdToGroup({
    @required this.consultancy,
  });
}

class LiveChatEventRecieveMessage extends LiveChatEvent {
  final ChatModel chat;

  LiveChatEventRecieveMessage({
    @required this.chat,
  });
}
