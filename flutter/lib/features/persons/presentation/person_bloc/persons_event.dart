part of 'persons_bloc.dart';

@immutable
sealed class PersonsEvent {}

final class PersonsEventFetchData extends PersonsEvent {
  final String? name;
  final int? fromAge;
  final int? toAge;

  PersonsEventFetchData({this.name, this.fromAge, this.toAge});
}

final class PersonsEventDeletePerson extends PersonsEvent {
  final int id;

  PersonsEventDeletePerson(this.id);
}

final class PersonsEventAddPerson extends PersonsEvent {
  final String name;
  final int age;

  PersonsEventAddPerson({required this.name, required this.age});
}
