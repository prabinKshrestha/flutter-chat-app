part of 'chat_repository.dart';

class ChatAPIProvider extends BaseAPIProvider {
  ChatAPIProvider({@required httpClient}) : super(httpClient: httpClient);

  Future<List> getChatsByConsultancyId(int consultancyId) async {
    return await getAction<List>("Chat/$consultancyId");
  }

  Future<void> sendMessage(Map<String, dynamic> data) async {
    return await postAction<void>("Chat", data, true);
  }
}
