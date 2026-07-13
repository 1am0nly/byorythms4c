import 'package:drift/drift.dart';
import 'app_database.dart';
import '../models/person.dart';

part 'person_dao.g.dart';

@DriftAccessor(tables: [Persons])
class PersonDao extends DatabaseAccessor<AppDatabase> with _$PersonDaoMixin {
  PersonDao(super.db);

  Stream<List<Person>> watchAll() {
    return select(persons).watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<List<Person>> getAll() async {
    final rows = await select(persons).get();
    return rows.map(_toDomain).toList();
  }

  Future<int> addPerson(Person person) {
    return into(persons).insert(PersonsCompanion(
      name: Value(person.name),
      birthDate: Value(person.birthDate.millisecondsSinceEpoch),
    ));
  }

  Future<bool> updatePerson(Person person) {
    return update(persons).replace(PersonRow(
      id: _parseId(person.id),
      name: person.name,
      birthDate: person.birthDate.millisecondsSinceEpoch,
    ));
  }

  Future<int> deletePerson(String id) {
    final intId = _parseId(id);
    return (delete(persons)..where((t) => t.id.equals(intId))).go();
  }

  int _parseId(String id) {
    if (!id.startsWith('p_')) {
      throw ArgumentError('Invalid person id format: "$id" (expected prefix "p_")');
    }
    return int.parse(id.replaceFirst('p_', ''));
  }

  Person _toDomain(PersonRow row) {
    return Person(
      id: 'p_${row.id}',
      name: row.name,
      birthDate: DateTime.fromMillisecondsSinceEpoch(row.birthDate),
    );
  }
}
