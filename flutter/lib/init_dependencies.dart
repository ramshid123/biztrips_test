import 'package:get_it/get_it.dart';
import 'package:persons/features/persons/data/data_source/remote_data_source.dart';
import 'package:persons/features/persons/data/repository/repository.dart';
import 'package:persons/features/persons/domain/repository/repository.dart';
import 'package:persons/features/persons/domain/usecases/add_person.dart';
import 'package:persons/features/persons/domain/usecases/delete_person.dart';
import 'package:persons/features/persons/domain/usecases/get_all_persons.dart';
import 'package:persons/features/persons/presentation/cubits/selected_filter_cubit.dart';
import 'package:persons/features/persons/presentation/person_bloc/persons_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future initDependencies() async {
  final supabaseInstance = await Supabase.initialize(
    url: 'https://powlyrypaysjbqijtryc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvd2x5cnlwYXlzamJxaWp0cnljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIzODkyMDQsImV4cCI6MjA0Nzk2NTIwNH0.rwmZ7a1Boht-JoYjSp1pUkIJJQYk0R2fi9bDxfyzS4Y',
  );

  final supabaseClient = supabaseInstance.client;

  serviceLocator.registerLazySingleton(() => supabaseClient);

  initPerson();
}

void initPerson() {
  serviceLocator
    ..registerFactory<RemoteDataSource>(
        () => RemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<RemoteRepository>(
        () => RemoteRespositoryImpl(serviceLocator()))
    ..registerFactory(() => UseCaseGetAllPersons(serviceLocator()))
    ..registerFactory(() => UseCaseAddPerson(serviceLocator()))
    ..registerFactory(() => UseCaseDeletePerson(serviceLocator()))
    ..registerLazySingleton<PersonsBloc>(() => PersonsBloc(
          useCaseGetAllPersons: serviceLocator(),
          useCaseDeletePerson: serviceLocator(),
          useCaseAddPerson: serviceLocator(),
        ))
    ..registerLazySingleton<SelectedFilterCubit>(() => SelectedFilterCubit());
}
