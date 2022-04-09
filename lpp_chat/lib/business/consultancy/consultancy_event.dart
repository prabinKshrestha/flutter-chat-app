part of 'consultancy_bloc.dart';

@immutable
abstract class ConsultancyEvent {}

class ConsultancyEventInitial extends ConsultancyEvent {}

class ConsultancyEventRequest extends ConsultancyEvent {}
