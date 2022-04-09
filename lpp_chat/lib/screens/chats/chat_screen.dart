import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lpp_chat/business/chats/chat_bloc.dart';
import 'package:lpp_chat/business/chats/live_chat_bloc.dart';
import 'package:lpp_chat/models/chat_model.dart';
import 'package:lpp_chat/models/chat_request_model.dart';
import 'package:lpp_chat/models/consultancy_model.dart';

class ChatScreen extends StatefulWidget {
  final ConsultancyModel consultancy;
  final bool isClient;

  const ChatScreen({@required this.consultancy, @required this.isClient});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatModel> chats = [];
  ChatRequestModel _chatRequestModel;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chatRequestModel = ChatRequestModel(
      message: "",
      isClient: widget.isClient,
      fkConsultancyId: widget.consultancy.id,
      chatFile: null,
    );
    context.read<LiveChatBloc>().add(LiveChatEventAddConnectionIdToGroup(consultancy: widget.consultancy));
    context.read<ChatBloc>().add(ChatEventRequest(widget.consultancy.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatStateAddMessageSuccess) {
          _messageController.text = "";
          _chatRequestModel = _chatRequestModel.copyWith(message: "", chatFile: null);
          setState(() {});
        }
      },
      builder: (_, state) {
        return WillPopScope(
          onWillPop: () {
            context.read<LiveChatBloc>().add(LiveChatEventRemoveConnectionIdToGroup(consultancy: widget.consultancy));
            return Future.value(true);
          },
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.isClient ? 'Consultant: ${widget.consultancy.consultantName}' : 'Client : ${widget.consultancy.clientName}'),
              ),
              body: Builder(
                builder: (_) {
                  if (state is ChatStateFetchLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is ChatStateFetchError) {
                    return Center(child: Text("Error while fetching record", style: TextStyle(color: Colors.red)));
                  }
                  if (state is ChatStateDataCollection) {
                    chats.clear();
                    chats.addAll(state.chats);
                  }
                  return BlocConsumer<LiveChatBloc, LiveChatState>(
                    listener: (_, state2) {
                      if (state2 is LiveChatStateRecieveMessage) {
                        chats.add(state2.chat);
                        // this is not good code. Protype so ignored code
                        context.read<ChatBloc>().add(ChatEventAddRecieved(chats));
                      }
                      if (state2 is LiveChatStateReconnect) {
                        context.read<LiveChatBloc>().add(LiveChatEventAddConnectionIdToGroup(consultancy: widget.consultancy));
                      }
                    },
                    builder: (_, state2) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              reverse: true,
                              children: [
                                ...List.generate(chats.length, (index) => chatMessageContainer(context, index)),
                                Row(
                                  mainAxisAlignment: widget.isClient ? MainAxisAlignment.start : MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                                      margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: widget.isClient ? Colors.amber : Colors.amber.shade200,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Download file : '),
                                          SizedBox(width: 20),
                                          GestureDetector(
                                            onTap: () {
                                              final snackBar = SnackBar(
                                                content: Text('File is fakely Downloaded.'),
                                                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                                behavior: SnackBarBehavior.floating,
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            },
                                            child: Icon(Icons.file_download),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: widget.isClient ? MainAxisAlignment.start : MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                                      margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: widget.isClient ? Colors.amber : Colors.amber.shade200,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: Text('${widget.consultancy.text}'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          messageWriteContainer(context, state)
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget messageWriteContainer(BuildContext context, ChatState state) {
    return Container(
      height: 100,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (String val) {
                  _chatRequestModel = _chatRequestModel.copyWith(message: val, chatFile: _chatRequestModel.chatFile);
                },
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Message",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: GestureDetector(
                    child: Icon(Icons.attach_file, color: Colors.amber),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      FilePickerResult result = await FilePicker.platform.pickFiles();
                      if (result != null) {
                        File file = File(result.files.single.path);
                        _chatRequestModel = _chatRequestModel.copyWith(chatFile: file);
                      } else {
                        _chatRequestModel = _chatRequestModel.copyWith(chatFile: null);
                      }
                      setState(() {});
                    },
                  ),
                  suffixIcon: Builder(
                    builder: (_) {
                      if (state is ChatStateAddMessageLoading) {
                        return Transform.scale(scale: 0.5, child: CircularProgressIndicator(strokeWidth: 6));
                      } else {
                        return GestureDetector(
                          child: Icon(Icons.send, color: Colors.amber),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (_chatRequestModel.message.trim() != "" || _chatRequestModel.chatFile != null) {
                              context.read<ChatBloc>().add(ChatEventAddMessageRequest(_chatRequestModel));
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          if (_chatRequestModel.chatFile != null)
            Positioned(
              top: -5,
              left: 5,
              child: Align(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(blurRadius: 4, color: Colors.grey, offset: Offset(0, 4)),
                      BoxShadow(blurRadius: 0.5, color: Colors.grey, offset: Offset(0, 0)),
                    ],
                  ),
                  child: Text("File Attached", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Row chatMessageContainer(BuildContext context, int index) {
    ChatModel chat = chats[chats.length - index - 1];
    return Row(
      mainAxisAlignment: widget.isClient == chat.isClient ? MainAxisAlignment.start : MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isClient == chat.isClient ? Colors.amber : Colors.amber.shade200,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (chat.message != null && chat.message != "") Text('${chat.message}'),
              if (chat.fileUrl != null && chat.fileUrl != "")
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Download file : '),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        final snackBar = SnackBar(
                          content: Text('${chat.file} File is fakely Downloaded.'),
                          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Icon(Icons.file_download),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
