import '../../../core/ids.dart';

/// A person taking part in a party. Just a name now — expenses live at the
/// party level and reference participants by id.
class Participant {
  const Participant({required this.id, required this.name});

  factory Participant.create({required String name}) {
    return Participant(id: newId(), name: name);
  }

  final String id;
  final String name;

  Participant copyWith({String? name}) {
    return Participant(id: id, name: name ?? this.name);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}
