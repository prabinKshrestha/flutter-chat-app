part of 'consultancy_repository.dart';

class ConsultancyAPIProvider extends BaseAPIProvider {
  ConsultancyAPIProvider({@required httpClient}) : super(httpClient: httpClient);

  Future<List> getConsultancies() async {
    return await getAction<List>("Consultancy");
  }
}
