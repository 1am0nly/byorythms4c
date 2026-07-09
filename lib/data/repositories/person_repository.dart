import '../database/person_dao.dart';
import '../models/person.dart';

class PersonRepository {
  final PersonDao _dao;

  PersonRepository(this._dao);

  Stream<List<Person>> watchAll() => _dao.watchAll();

  Future<List<Person>> getAll() => _dao.getAll();

  Future<int> add(Person person) => _dao.addPerson(person);

  Future<bool> update(Person person) => _dao.updatePerson(person);

  Future<int> delete(String id) => _dao.deletePerson(id);
}
