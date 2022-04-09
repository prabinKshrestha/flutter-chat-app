import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lpp_chat/datas/chats/chat_repository.dart';
import 'package:lpp_chat/models/chat_model.dart';
import 'package:lpp_chat/models/chat_request_model.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({
    @required this.chatRepository,
  }) : super(ChatStateInitial());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatEventRequest) {
      yield ChatStateFetchLoading();
      try {
        yield ChatStateDataCollection(await chatRepository.getChatsByConsultancyId(event.consultancyId));
      } catch (_) {
        yield ChatStateFetchError();
      }
    }
    if (event is ChatEventAddMessageRequest) {
      yield ChatStateAddMessageLoading();
      try {
        await chatRepository.sendMessage(event.chat);
        yield ChatStateAddMessageSuccess();
      } catch (_) {
        yield ChatStateAddMessageError();
      }
    }
    if (event is ChatEventAddRecieved) {
      yield ChatStateDataCollection(event.chats);
    }
  }
}
