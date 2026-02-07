import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ComunitysRecord extends FirestoreRecord {
  ComunitysRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "comunityName" field.
  String? _comunityName;
  String get comunityName => _comunityName ?? '';
  bool hasComunityName() => _comunityName != null;

  // "locationComunity" field.
  LatLng? _locationComunity;
  LatLng? get locationComunity => _locationComunity;
  bool hasLocationComunity() => _locationComunity != null;

  void _initializeFields() {
    _comunityName = snapshotData['comunityName'] as String?;
    _locationComunity = snapshotData['locationComunity'] as LatLng?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('comunitys');

  static Stream<ComunitysRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ComunitysRecord.fromSnapshot(s));

  static Future<ComunitysRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ComunitysRecord.fromSnapshot(s));

  static ComunitysRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ComunitysRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ComunitysRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ComunitysRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ComunitysRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ComunitysRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createComunitysRecordData({
  String? comunityName,
  LatLng? locationComunity,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'comunityName': comunityName,
      'locationComunity': locationComunity,
    }.withoutNulls,
  );

  return firestoreData;
}

class ComunitysRecordDocumentEquality implements Equality<ComunitysRecord> {
  const ComunitysRecordDocumentEquality();

  @override
  bool equals(ComunitysRecord? e1, ComunitysRecord? e2) {
    return e1?.comunityName == e2?.comunityName &&
        e1?.locationComunity == e2?.locationComunity;
  }

  @override
  int hash(ComunitysRecord? e) =>
      const ListEquality().hash([e?.comunityName, e?.locationComunity]);

  @override
  bool isValidKey(Object? o) => o is ComunitysRecord;
}
