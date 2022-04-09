import 'package:flutter/material.dart';
import 'package:lpp_chat/models/consultancy_model.dart';

import '../base_api_provider.dart';

part 'consultancy_api_provider.dart';

class ConsultancyRepository {
  final ConsultancyAPIProvider consultancyAPIProvider;

  ConsultancyRepository({@required this.consultancyAPIProvider});

  Future<List<ConsultancyModel>> getConsultancies() async {
    return (await consultancyAPIProvider.getConsultancies()).map((e) => ConsultancyModel.fromMap(e)).toList();
  }
}
