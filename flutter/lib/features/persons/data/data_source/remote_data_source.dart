// ignore_for_file: unnecessary_null_comparison

import 'package:persons/core/errors/kustom_exception.dart';
import 'package:persons/features/persons/data/model/person_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RemoteDataSource {
  Future<List<PersonModel>> getAllPersons({int? fromAge, int? toAge, String? name});

  Future<void> addPerson(PersonModel personModel);

  Future<void> deletePerson(int id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final SupabaseClient supabaseClient;

  RemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<PersonModel>> getAllPersons(
      {int? fromAge, int? toAge, String? name}) async {
    try {
      final response = await supabaseClient
          .from('users')
          .select()
          .ilike(name == null ? '' : 'name', '%$name%')
          .gte(fromAge == null ? '' : 'age', fromAge ?? 0)
          .lte(toAge == null ? '' : 'age', toAge ?? 0);
      return response.map((element) => PersonModel.fromJson(element)).toList();
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future<void> addPerson(PersonModel personModel) async {
    try {
      await supabaseClient.from('users').insert({
        'name': personModel.name,
        'age': personModel.age,
      });
    } catch (e) {
      throw KustomException(e.toString());
    }
  }

  @override
  Future<void> deletePerson(int id) async {
    try {
      await supabaseClient.from('users').delete().match({'id': id});
    } catch (e) {
      throw KustomException(e.toString());
    }
  }
}
