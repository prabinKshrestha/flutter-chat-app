import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lpp_chat/constants/app_constant.dart';
import 'package:lpp_chat/models/chat_model.dart';
import 'package:lpp_chat/models/consultancy_model.dart';
import 'package:meta/meta.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';

part 'live_chat_event.dart';
part 'live_chat_state.dart';

class LiveChatBloc extends Bloc<LiveChatEvent, LiveChatState> {
  HubConnection hubConnection;
  LiveChatBloc() : super(LiveChatStateInitial());

  Future<String> _getToken() {
    // We need to keep on updating the
    return Future.value("${AppConstant.JWT_TOKEN}");
  }

  @override
  Stream<LiveChatState> mapEventToState(LiveChatEvent event) async* {
    if (event is LiveChatEventRecieveMessage) {
      yield LiveChatStateRecieveMessage(chat: event.chat);
    }
    if (event is LiveChatEventConnectSignalR) {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });

      // hubConnection = HubConnectionBuilder().withUrl('${AppConstant.TOTAL_BASE_URL}/chathub').build();

      hubConnection = HubConnectionBuilder()
          .withUrl(
            '${AppConstant.TOTAL_BASE_URL}/chathub',
            options: HttpConnectionOptions(
              accessTokenFactory: () async => await _getToken(),
              logger: Logger("SignalR - transport"),
            ),
          )
          .configureLogging(Logger("SignalR - hub"))
          .withAutomaticReconnect()
          .build();
      // double the time of in keep server alive in server side
      // in milli second
      // 2 minute
      hubConnection.serverTimeoutInMilliseconds = 2 * 60 * 1000;

      hubConnection.onclose(({error}) => Future.delayed(Duration(seconds: 5), () async => await startHubconnection()));

      hubConnection.on('StreamMessageAsync', (message) async {
        if (message != null && message.length > 0 && message[0] != null) {
          add(LiveChatEventRecieveMessage(chat: ChatModel.fromMap(message[0])));
        }
      });

      await startHubconnection();
    }
    if (event is LiveChatEventReConnectSignalR) {
      yield LiveChatStateReconnect();
    }
    if (event is LiveChatEventAddConnectionIdToGroup) {
      await hubConnection.invoke("AddToGroup", args: <Object>[event.consultancy.id.toString()]);
    }
    if (event is LiveChatEventRemoveConnectionIdToGroup) {
      await hubConnection.invoke("RemoveFromGroup", args: <Object>[event.consultancy.id.toString()]);
    }
  }

  Future<void> startHubconnection() async {
    await hubConnection.start().then(
          (value) => add(LiveChatEventReConnectSignalR()),
          onError: (error, stackTrace) => Future.delayed(Duration(seconds: 5), () async => await startHubconnection()),
        );
  }
}
