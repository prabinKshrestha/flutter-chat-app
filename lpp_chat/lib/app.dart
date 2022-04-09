import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lpp_chat/business/chats/chat_bloc.dart';
import 'package:lpp_chat/business/chats/live_chat_bloc.dart';
import 'package:lpp_chat/datas/consultancy/consultancy_repository.dart';
import 'package:lpp_chat/screens/home/home_screen.dart';

import 'business/consultancy/consultancy_bloc.dart';
import 'datas/chats/chat_repository.dart';

class App extends StatelessWidget {
  final ConsultancyRepository consultancyRepository;
  final ChatRepository chatRepository;

  const App({
    @required this.consultancyRepository,
    @required this.chatRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ConsultancyRepository>(create: (_) => consultancyRepository),
        RepositoryProvider<ChatRepository>(create: (_) => chatRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ConsultancyBloc>(create: (_) => ConsultancyBloc(consultancyRepository: consultancyRepository)),
          BlocProvider<ChatBloc>(create: (_) => ChatBloc(chatRepository: chatRepository)),
          BlocProvider<LiveChatBloc>(create: (_) => LiveChatBloc()..add(LiveChatEventConnectSignalR())),
        ],
        child: MaterialApp(
          title: 'LPP Chat Prototype',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.blueAccent,
            secondaryHeaderColor: Colors.amber,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              brightness: Brightness.dark,
            ),
          ),
          home: HomeScreen(),
        ),
      ),
    );
  }
}
