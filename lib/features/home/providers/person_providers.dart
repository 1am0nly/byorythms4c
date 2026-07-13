import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/data/database/providers.dart';
import 'package:biorhythms_flutter/data/models/person.dart';
import 'package:biorhythms_flutter/data/repositories/person_repository.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';
import 'date_providers.dart';

final personRepositoryProvider = Provider<PersonRepository>((ref) {
  return PersonRepository(ref.watch(personDaoProvider));
});

final personsProvider = StreamProvider<List<Person>>((ref) {
  return ref.watch(personRepositoryProvider).watchAll();
});

final selectedPersonIdProvider =
    AsyncNotifierProvider<SelectedPersonIdNotifier, String>(
  SelectedPersonIdNotifier.new,
);

class SelectedPersonIdNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    final dao = ref.read(settingsDaoProvider);
    final saved = await dao.get('selectedPersonId');
    return (saved != null && saved.isNotEmpty) ? saved : '';
  }

  Future<void> select(String id) async {
    state = AsyncData(id);
    final dao = ref.read(settingsDaoProvider);
    await dao.set('selectedPersonId', id);
  }
}

final selectedPersonProvider = Provider<Person?>((ref) {
  final personsAsync = ref.watch(personsProvider);
  final persons = personsAsync.valueOrNull ?? [];
  final selectedIdAsync = ref.watch(selectedPersonIdProvider);
  final selectedId = selectedIdAsync.valueOrNull ?? '';
  if (selectedId.isEmpty && persons.isNotEmpty) return persons.first;
  try {
    return persons.firstWhere((p) => p.id == selectedId);
  } catch (_) {
    return persons.isNotEmpty ? persons.first : null;
  }
});

final selectedSnapshotProvider = Provider<BiorhythmSnapshot>((ref) {
  final person = ref.watch(selectedPersonProvider);
  final focusDate = ref.watch(focusDateProvider);
  if (person == null) {
    // No profile selected — return a zeroed snapshot instead of using focusDate as birthDate.
    return BiorhythmCalculator.calculate(
      birthDate: focusDate,
      targetDate: focusDate,
    );
  }
  return BiorhythmCalculator.calculate(
    birthDate: person.birthDate,
    targetDate: focusDate,
  );
});
