part of 'persons_bloc.dart';

@immutable
sealed class PersonsState {}

final class PersonsInitial extends PersonsState {}

final class PersonsStateFailure extends PersonsState {
  final String errorMsg;

  PersonsStateFailure(this.errorMsg);
}

final class PersonsStateLoading extends PersonsState {}

final class PersonsStatePersons extends PersonsState {
  final List<PersonEntity> persons;

  PersonsStatePersons(this.persons);
}
