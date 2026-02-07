import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EventsRecord extends FirestoreRecord {
  EventsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "eventFoto" field.
  String? _eventFoto;
  String get eventFoto => _eventFoto ?? '';
  bool hasEventFoto() => _eventFoto != null;

  // "eventDescription" field.
  String? _eventDescription;
  String get eventDescription => _eventDescription ?? '';
  bool hasEventDescription() => _eventDescription != null;

  // "maximodepessoas" field.
  int? _maximodepessoas;
  int get maximodepessoas => _maximodepessoas ?? 0;
  bool hasMaximodepessoas() => _maximodepessoas != null;

  // "comprarkitadiantado" field.
  bool? _comprarkitadiantado;
  bool get comprarkitadiantado => _comprarkitadiantado ?? false;
  bool hasComprarkitadiantado() => _comprarkitadiantado != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "horario" field.
  DateTime? _horario;
  DateTime? get horario => _horario;
  bool hasHorario() => _horario != null;

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "kit" field.
  List<EventKitStruct>? _kit;
  List<EventKitStruct> get kit => _kit ?? const [];
  bool hasKit() => _kit != null;

  // "complement" field.
  String? _complement;
  String get complement => _complement ?? '';
  bool hasComplement() => _complement != null;

  // "usersRegistration" field.
  List<DocumentReference>? _usersRegistration;
  List<DocumentReference> get usersRegistration =>
      _usersRegistration ?? const [];
  bool hasUsersRegistration() => _usersRegistration != null;

  // "interesseUsers" field.
  List<DocumentReference>? _interesseUsers;
  List<DocumentReference> get interesseUsers => _interesseUsers ?? const [];
  bool hasInteresseUsers() => _interesseUsers != null;

  void _initializeFields() {
    _eventFoto = snapshotData['eventFoto'] as String?;
    _eventDescription = snapshotData['eventDescription'] as String?;
    _maximodepessoas = castToType<int>(snapshotData['maximodepessoas']);
    _comprarkitadiantado = snapshotData['comprarkitadiantado'] as bool?;
    _location = snapshotData['location'] as LatLng?;
    _horario = snapshotData['horario'] as DateTime?;
    _user = snapshotData['user'] as DocumentReference?;
    _kit = getStructList(
      snapshotData['kit'],
      EventKitStruct.fromMap,
    );
    _complement = snapshotData['complement'] as String?;
    _usersRegistration = getDataList(snapshotData['usersRegistration']);
    _interesseUsers = getDataList(snapshotData['interesseUsers']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('events');

  static Stream<EventsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EventsRecord.fromSnapshot(s));

  static Future<EventsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EventsRecord.fromSnapshot(s));

  static EventsRecord fromSnapshot(DocumentSnapshot snapshot) => EventsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EventsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EventsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EventsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EventsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEventsRecordData({
  String? eventFoto,
  String? eventDescription,
  int? maximodepessoas,
  bool? comprarkitadiantado,
  LatLng? location,
  DateTime? horario,
  DocumentReference? user,
  String? complement,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'eventFoto': eventFoto,
      'eventDescription': eventDescription,
      'maximodepessoas': maximodepessoas,
      'comprarkitadiantado': comprarkitadiantado,
      'location': location,
      'horario': horario,
      'user': user,
      'complement': complement,
    }.withoutNulls,
  );

  return firestoreData;
}

class EventsRecordDocumentEquality implements Equality<EventsRecord> {
  const EventsRecordDocumentEquality();

  @override
  bool equals(EventsRecord? e1, EventsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.eventFoto == e2?.eventFoto &&
        e1?.eventDescription == e2?.eventDescription &&
        e1?.maximodepessoas == e2?.maximodepessoas &&
        e1?.comprarkitadiantado == e2?.comprarkitadiantado &&
        e1?.location == e2?.location &&
        e1?.horario == e2?.horario &&
        e1?.user == e2?.user &&
        listEquality.equals(e1?.kit, e2?.kit) &&
        e1?.complement == e2?.complement &&
        listEquality.equals(e1?.usersRegistration, e2?.usersRegistration) &&
        listEquality.equals(e1?.interesseUsers, e2?.interesseUsers);
  }

  @override
  int hash(EventsRecord? e) => const ListEquality().hash([
        e?.eventFoto,
        e?.eventDescription,
        e?.maximodepessoas,
        e?.comprarkitadiantado,
        e?.location,
        e?.horario,
        e?.user,
        e?.kit,
        e?.complement,
        e?.usersRegistration,
        e?.interesseUsers
      ]);

  @override
  bool isValidKey(Object? o) => o is EventsRecord;
}
