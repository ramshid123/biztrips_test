
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:persons/core/errors/kfailure.dart';
import 'package:persons/features/persons/domain/entities/person_entity.dart';
import 'package:persons/features/persons/domain/usecases/add_person.dart';
import 'package:persons/features/persons/domain/usecases/delete_person.dart';
import 'package:persons/features/persons/domain/usecases/get_all_persons.dart';

part 'persons_event.dart';
part 'persons_state.dart';

class PersonsBloc extends Bloc<PersonsEvent, PersonsState> {
  final UseCaseGetAllPersons _useCaseGetAllPersons;
  final UseCaseAddPerson _useCaseAddPerson;
  final UseCaseDeletePerson _useCaseDeletePerson;

  PersonsBloc({
    required UseCaseDeletePerson useCaseDeletePerson,
    required UseCaseGetAllPersons useCaseGetAllPersons,
    required UseCaseAddPerson useCaseAddPerson,
  })  : _useCaseGetAllPersons = useCaseGetAllPersons,
        _useCaseDeletePerson = useCaseDeletePerson,
        _useCaseAddPerson = useCaseAddPerson,
        super(PersonsInitial()) {
    on<PersonsEventFetchData>(
        (event, emit) async => _onPersonsEventFetchData(event, emit));

    on<PersonsEventAddPerson>(
        (event, emit) async => await _onPersonsEventAddPerson(event, emit));

    on<PersonsEventDeletePerson>(
        (event, emit) async => await _onPersonsEventDeletePerson(event, emit));
  }

  Future _onPersonsEventDeletePerson(
      PersonsEventDeletePerson event, Emitter<PersonsState> emit) async {
    final response =
        await _useCaseDeletePerson(UseCaseDeletePersonParams(event.id));

    response.fold(
      (l) {
        emit(PersonsStateFailure(l.errorMsg));
      },
      (r) {},
    );
  }

  Future<Either<KFailure, List<PersonEntity>>> _fetchPersonsData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final response = await _useCaseGetAllPersons(UseCaseGetAllPersonsParams());
    return response;
  }

  Future _onPersonsEventFetchData(
      PersonsEventFetchData event, Emitter<PersonsState> emit) async {
    emit(PersonsStateLoading());

    final response = await _fetchPersonsData();

    response.fold(
      (l) {
        emit(PersonsStateFailure(l.errorMsg));
      },
      (r) {
        emit(PersonsStatePersons(r));
      },
    );
  }

  Future _onPersonsEventAddPerson(
      PersonsEventAddPerson event, Emitter<PersonsState> emit) async {
    emit(PersonsStateLoading());

    final resopnse = await _useCaseAddPerson(
        UseCaseAddPersonParams(name: event.name, age: event.age));

    resopnse.fold(
      (l) {
        emit(PersonsStateFailure(l.errorMsg));
      },
      (r) {},
    );
  }
}
