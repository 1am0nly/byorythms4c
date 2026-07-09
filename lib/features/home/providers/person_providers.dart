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
    NotifierProvider<SelectedPersonIdNotifier, String>(
  SelectedPersonIdNotifier.new,
);

class SelectedPersonIdNotifier extends Notifier<String> {
  @override
  String build() {
    _init();
    return '';
  }

  Future<void> _init() async {
    final dao = ref.read(settingsDaoProvider);
    final saved = await dao.get('selectedPersonId');
    if (saved != null && saved.isNotEmpty) {
      state = saved;
    }
  }

  void select(String id) {
    state = id;
    _save();
  }

  Future<void> _save() async {
    final dao = ref.read(settingsDaoProvider);
    await dao.set('selectedPersonId', state);
  }
}

final selectedPersonProvider = Provider<Person?>((ref) {
  final personsAsync = ref.watch(personsProvider);
  final persons = personsAsync.valueOrNull ?? [];
  final selectedId = ref.watch(selectedPersonIdProvider);
  try {
    return persons.firstWhere((p) => p.id == selectedId);
  } catch (_) {
    return persons.isNotEmpty ? persons.first : null;
  }
});

final selectedSnapshotProvider = Provider<BiorhythmSnapshot>((ref) {
  final person = ref.watch(selectedPersonProvider);
  final focusDate = ref.watch(focusDateProvider);
  return BiorhythmCalculator.calculate(
    birthDate: person?.birthDate ?? focusDate,
    targetDate: focusDate,
  );
});
