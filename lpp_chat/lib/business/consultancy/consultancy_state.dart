part of 'consultancy_bloc.dart';

@immutable
abstract class ConsultancyState {}

class ConsultancyStateInitial extends ConsultancyState {}

class ConsultancyStateFetchLoading extends ConsultancyState {}

class ConsultancyStateFetchSuccess extends ConsultancyState {
  final List<ConsultancyModel> consultancies;

  ConsultancyStateFetchSuccess({
    @required this.consultancies,
  });
}

class ConsultancyStateFetchError extends ConsultancyState {}
