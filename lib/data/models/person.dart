class Person {
  final String id;
  final String name;
  final DateTime birthDate;

  const Person({
    required this.id,
    required this.name,
    required this.birthDate,
  });

  Person copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}
