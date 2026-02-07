import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RideOrdersRecord extends FirestoreRecord {
  RideOrdersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "sos" field.
  bool? _sos;
  bool get sos => _sos ?? false;
  bool hasSos() => _sos != null;

  // "driver" field.
  DocumentReference? _driver;
  DocumentReference? get driver => _driver;
  bool hasDriver() => _driver != null;

  // "users" field.
  DocumentReference? _users;
  DocumentReference? get users => _users;
  bool hasUsers() => _users != null;

  void _initializeFields() {
    _sos = snapshotData['sos'] as bool?;
    _driver = snapshotData['driver'] as DocumentReference?;
    _users = snapshotData['users'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('rideOrders');

  static Stream<RideOrdersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RideOrdersRecord.fromSnapshot(s));

  static Future<RideOrdersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RideOrdersRecord.fromSnapshot(s));

  static RideOrdersRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RideOrdersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RideOrdersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RideOrdersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RideOrdersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RideOrdersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRideOrdersRecordData({
  bool? sos,
  DocumentReference? driver,
  DocumentReference? users,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'sos': sos,
      'driver': driver,
      'users': users,
    }.withoutNulls,
  );

  return firestoreData;
}

class RideOrdersRecordDocumentEquality implements Equality<RideOrdersRecord> {
  const RideOrdersRecordDocumentEquality();

  @override
  bool equals(RideOrdersRecord? e1, RideOrdersRecord? e2) {
    return e1?.sos == e2?.sos &&
        e1?.driver == e2?.driver &&
        e1?.users == e2?.users;
  }

  @override
  int hash(RideOrdersRecord? e) =>
      const ListEquality().hash([e?.sos, e?.driver, e?.users]);

  @override
  bool isValidKey(Object? o) => o is RideOrdersRecord;
}
