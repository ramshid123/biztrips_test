
import 'package:persons/core/errors/kustom_exception.dart';
import 'package:persons/features/persons/data/model/person_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RemoteDataSource {
  Future<List<PersonModel>> getAllPersons();

  Future<void> addPerson(PersonModel personModel);

  Future<void> deletePerson(int id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final SupabaseClient supabaseClient;

  RemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<PersonModel>> getAllPersons() async {
    try {
      final response = await supabaseClient.from('users').select();
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
