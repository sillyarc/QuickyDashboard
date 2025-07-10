import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PagamentosRecord extends FirestoreRecord {
  PagamentosRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "paymentId" field.
  String? _paymentId;
  String get paymentId => _paymentId ?? '';
  bool hasPaymentId() => _paymentId != null;

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  bool hasValor() => _valor != null;

  // "tasks" field.
  DocumentReference? _tasks;
  DocumentReference? get tasks => _tasks;
  bool hasTasks() => _tasks != null;

  // "data" field.
  DateTime? _data;
  DateTime? get data => _data;
  bool hasData() => _data != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _paymentId = snapshotData['paymentId'] as String?;
    _valor = castToType<double>(snapshotData['valor']);
    _tasks = snapshotData['tasks'] as DocumentReference?;
    _data = snapshotData['data'] as DateTime?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('pagamentos')
          : FirebaseFirestore.instance.collectionGroup('pagamentos');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('pagamentos').doc(id);

  static Stream<PagamentosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PagamentosRecord.fromSnapshot(s));

  static Future<PagamentosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PagamentosRecord.fromSnapshot(s));

  static PagamentosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PagamentosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PagamentosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PagamentosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PagamentosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PagamentosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPagamentosRecordData({
  String? paymentId,
  double? valor,
  DocumentReference? tasks,
  DateTime? data,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'paymentId': paymentId,
      'valor': valor,
      'tasks': tasks,
      'data': data,
    }.withoutNulls,
  );

  return firestoreData;
}

class PagamentosRecordDocumentEquality implements Equality<PagamentosRecord> {
  const PagamentosRecordDocumentEquality();

  @override
  bool equals(PagamentosRecord? e1, PagamentosRecord? e2) {
    return e1?.paymentId == e2?.paymentId &&
        e1?.valor == e2?.valor &&
        e1?.tasks == e2?.tasks &&
        e1?.data == e2?.data;
  }

  @override
  int hash(PagamentosRecord? e) =>
      const ListEquality().hash([e?.paymentId, e?.valor, e?.tasks, e?.data]);

  @override
  bool isValidKey(Object? o) => o is PagamentosRecord;
}
