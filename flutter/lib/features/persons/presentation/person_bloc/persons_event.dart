part of 'persons_bloc.dart';

@immutable
sealed class PersonsEvent {}

final class PersonsEventFetchData extends PersonsEvent {}

final class PersonsEventDeletePerson extends PersonsEvent {
  final int id;

  PersonsEventDeletePerson(this.id);
}

final class PersonsEventAddPerson extends PersonsEvent {
  final String name;
  final int age;

  PersonsEventAddPerson({required this.name, required this.age});
}
