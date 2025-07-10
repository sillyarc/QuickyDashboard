import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TasksPreProntasRecord extends FirestoreRecord {
  TasksPreProntasRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "categoria" field.
  String? _categoria;
  String get categoria => _categoria ?? '';
  bool hasCategoria() => _categoria != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  bool hasDescricao() => _descricao != null;

  // "duracao" field.
  List<String>? _duracao;
  List<String> get duracao => _duracao ?? const [];
  bool hasDuracao() => _duracao != null;

  // "material" field.
  List<String>? _material;
  List<String> get material => _material ?? const [];
  bool hasMaterial() => _material != null;

  // "materialCusto" field.
  double? _materialCusto;
  double get materialCusto => _materialCusto ?? 0.0;
  bool hasMaterialCusto() => _materialCusto != null;

  // "preco" field.
  double? _preco;
  double get preco => _preco ?? 0.0;
  bool hasPreco() => _preco != null;

  // "steps" field.
  List<String>? _steps;
  List<String> get steps => _steps ?? const [];
  bool hasSteps() => _steps != null;

  // "titulo" field.
  String? _titulo;
  String get titulo => _titulo ?? '';
  bool hasTitulo() => _titulo != null;

  // "foto" field.
  String? _foto;
  String get foto => _foto ?? '';
  bool hasFoto() => _foto != null;

  void _initializeFields() {
    _categoria = snapshotData['categoria'] as String?;
    _descricao = snapshotData['descricao'] as String?;
    _duracao = getDataList(snapshotData['duracao']);
    _material = getDataList(snapshotData['material']);
    _materialCusto = castToType<double>(snapshotData['materialCusto']);
    _preco = castToType<double>(snapshotData['preco']);
    _steps = getDataList(snapshotData['steps']);
    _titulo = snapshotData['titulo'] as String?;
    _foto = snapshotData['foto'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('tasksPreProntas');

  static Stream<TasksPreProntasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TasksPreProntasRecord.fromSnapshot(s));

  static Future<TasksPreProntasRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TasksPreProntasRecord.fromSnapshot(s));

  static TasksPreProntasRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TasksPreProntasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TasksPreProntasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TasksPreProntasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TasksPreProntasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TasksPreProntasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTasksPreProntasRecordData({
  String? categoria,
  String? descricao,
  double? materialCusto,
  double? preco,
  String? titulo,
  String? foto,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'categoria': categoria,
      'descricao': descricao,
      'materialCusto': materialCusto,
      'preco': preco,
      'titulo': titulo,
      'foto': foto,
    }.withoutNulls,
  );

  return firestoreData;
}

class TasksPreProntasRecordDocumentEquality
    implements Equality<TasksPreProntasRecord> {
  const TasksPreProntasRecordDocumentEquality();

  @override
  bool equals(TasksPreProntasRecord? e1, TasksPreProntasRecord? e2) {
    const listEquality = ListEquality();
    return e1?.categoria == e2?.categoria &&
        e1?.descricao == e2?.descricao &&
        listEquality.equals(e1?.duracao, e2?.duracao) &&
        listEquality.equals(e1?.material, e2?.material) &&
        e1?.materialCusto == e2?.materialCusto &&
        e1?.preco == e2?.preco &&
        listEquality.equals(e1?.steps, e2?.steps) &&
        e1?.titulo == e2?.titulo &&
        e1?.foto == e2?.foto;
  }

  @override
  int hash(TasksPreProntasRecord? e) => const ListEquality().hash([
        e?.categoria,
        e?.descricao,
        e?.duracao,
        e?.material,
        e?.materialCusto,
        e?.preco,
        e?.steps,
        e?.titulo,
        e?.foto
      ]);

  @override
  bool isValidKey(Object? o) => o is TasksPreProntasRecord;
}
