import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lpp_chat/datas/consultancy/consultancy_repository.dart';
import 'package:lpp_chat/models/consultancy_model.dart';
import 'package:meta/meta.dart';

part 'consultancy_event.dart';
part 'consultancy_state.dart';

class ConsultancyBloc extends Bloc<ConsultancyEvent, ConsultancyState> {
  final ConsultancyRepository consultancyRepository;

  ConsultancyBloc({@required this.consultancyRepository}) : super(ConsultancyStateInitial());

  @override
  Stream<ConsultancyState> mapEventToState(ConsultancyEvent event) async* {
    if (event is ConsultancyEventRequest) {
      yield ConsultancyStateFetchLoading();
      try {
        yield ConsultancyStateFetchSuccess(consultancies: await consultancyRepository.getConsultancies());
      } catch (_) {
        yield ConsultancyStateFetchError();
      }
    }
  }
}
