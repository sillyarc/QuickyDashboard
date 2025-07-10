import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TasksRecord extends FirestoreRecord {
  TasksRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Foto" field.
  List<String>? _foto;
  List<String> get foto => _foto ?? const [];
  bool hasFoto() => _foto != null;

  // "Titulo" field.
  String? _titulo;
  String get titulo => _titulo ?? '';
  bool hasTitulo() => _titulo != null;

  // "Categoria" field.
  String? _categoria;
  String get categoria => _categoria ?? '';
  bool hasCategoria() => _categoria != null;

  // "Descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "userReference" field.
  DocumentReference? _userReference;
  DocumentReference? get userReference => _userReference;
  bool hasUserReference() => _userReference != null;

  // "usuarioQueAceitouaTask" field.
  DocumentReference? _usuarioQueAceitouaTask;
  DocumentReference? get usuarioQueAceitouaTask => _usuarioQueAceitouaTask;
  bool hasUsuarioQueAceitouaTask() => _usuarioQueAceitouaTask != null;

  // "datadecriacaodatask" field.
  DateTime? _datadecriacaodatask;
  DateTime? get datadecriacaodatask => _datadecriacaodatask;
  bool hasDatadecriacaodatask() => _datadecriacaodatask != null;

  void _initializeFields() {
    _foto = getDataList(snapshotData['Foto']);
    _titulo = snapshotData['Titulo'] as String?;
    _categoria = snapshotData['Categoria'] as String?;
    _descricao = snapshotData['Descricao'] as String?;
    _status = snapshotData['status'] as String?;
    _userReference = snapshotData['userReference'] as DocumentReference?;
    _usuarioQueAceitouaTask =
        snapshotData['usuarioQueAceitouaTask'] as DocumentReference?;
    _datadecriacaodatask = snapshotData['datadecriacaodatask'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('tasks');

  static Stream<TasksRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TasksRecord.fromSnapshot(s));

  static Future<TasksRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TasksRecord.fromSnapshot(s));

  static TasksRecord fromSnapshot(DocumentSnapshot snapshot) => TasksRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TasksRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TasksRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TasksRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TasksRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTasksRecordData({
  String? titulo,
  String? categoria,
  String? descricao,
  String? status,
  DocumentReference? userReference,
  DocumentReference? usuarioQueAceitouaTask,
  DateTime? datadecriacaodatask,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Titulo': titulo,
      'Categoria': categoria,
      'Descricao': descricao,
      'status': status,
      'userReference': userReference,
      'usuarioQueAceitouaTask': usuarioQueAceitouaTask,
      'datadecriacaodatask': datadecriacaodatask,
    }.withoutNulls,
  );

  return firestoreData;
}

class TasksRecordDocumentEquality implements Equality<TasksRecord> {
  const TasksRecordDocumentEquality();

  @override
  bool equals(TasksRecord? e1, TasksRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.foto, e2?.foto) &&
        e1?.titulo == e2?.titulo &&
        e1?.categoria == e2?.categoria &&
        e1?.descricao == e2?.descricao &&
        e1?.status == e2?.status &&
        e1?.userReference == e2?.userReference &&
        e1?.usuarioQueAceitouaTask == e2?.usuarioQueAceitouaTask &&
        e1?.datadecriacaodatask == e2?.datadecriacaodatask;
  }

  @override
  int hash(TasksRecord? e) => const ListEquality().hash([
        e?.foto,
        e?.titulo,
        e?.categoria,
        e?.descricao,
        e?.status,
        e?.userReference,
        e?.usuarioQueAceitouaTask,
        e?.datadecriacaodatask
      ]);

  @override
  bool isValidKey(Object? o) => o is TasksRecord;
}
