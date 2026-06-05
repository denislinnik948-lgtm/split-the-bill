import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/party.dart';

/// Local, offline-first persistence for parties.
///
/// Abstracted so the UI and state layer depend on an interface, letting tests
/// (and previews) swap in an in-memory implementation instead of real storage.
abstract class PartyRepository {
  /// The single in-progress draft, if any.
  Party? getDraft();

  /// Completed parties, newest first.
  List<Party> getCompleted();

  Party? getById(String id);

  Future<void> save(Party party);

  Future<void> delete(String id);
}

/// Hive-backed repository. Parties are stored as JSON strings in a single box
/// keyed by party id, which keeps the models free of generated adapters while
/// still surviving app restarts.
class HivePartyRepository implements PartyRepository {
  HivePartyRepository(this._box);

  static const String boxName = 'parties';

  final Box<String> _box;

  List<Party> _all() {
    return _box.values
        .map((raw) => Party.fromJson(jsonDecode(raw) as Map<String, dynamic>))
        .toList();
  }

  @override
  Party? getDraft() {
    for (final party in _all()) {
      if (party.isDraft) return party;
    }
    return null;
  }

  @override
  List<Party> getCompleted() {
    return _all().where((p) => p.status == PartyStatus.completed).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Party? getById(String id) {
    final raw = _box.get(id);
    if (raw == null) return null;
    return Party.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> save(Party party) {
    return _box.put(party.id, jsonEncode(party.toJson()));
  }

  @override
  Future<void> delete(String id) {
    return _box.delete(id);
  }
}

/// In-memory repository for tests and previews. No persistence across restarts.
class InMemoryPartyRepository implements PartyRepository {
  final Map<String, Party> _store = {};

  @override
  Party? getDraft() {
    for (final party in _store.values) {
      if (party.isDraft) return party;
    }
    return null;
  }

  @override
  List<Party> getCompleted() {
    return _store.values
        .where((p) => p.status == PartyStatus.completed)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Party? getById(String id) => _store[id];

  @override
  Future<void> save(Party party) async {
    _store[party.id] = party;
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
  }
}
