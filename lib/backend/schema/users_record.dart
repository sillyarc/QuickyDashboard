import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "lastActive" field.
  DateTime? _lastActive;
  DateTime? get lastActive => _lastActive;
  bool hasLastActive() => _lastActive != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "tasksCompleted" field.
  List<DocumentReference>? _tasksCompleted;
  List<DocumentReference> get tasksCompleted => _tasksCompleted ?? const [];
  bool hasTasksCompleted() => _tasksCompleted != null;

  // "requestPedidos" field.
  List<DocumentReference>? _requestPedidos;
  List<DocumentReference> get requestPedidos => _requestPedidos ?? const [];
  bool hasRequestPedidos() => _requestPedidos != null;

  // "requestEmNumber" field.
  int? _requestEmNumber;
  int get requestEmNumber => _requestEmNumber ?? 0;
  bool hasRequestEmNumber() => _requestEmNumber != null;

  // "plataform" field.
  List<String>? _plataform;
  List<String> get plataform => _plataform ?? const [];
  bool hasPlataform() => _plataform != null;

  // "taskOrTaskee" field.
  String? _taskOrTaskee;
  String get taskOrTaskee => _taskOrTaskee ?? '';
  bool hasTaskOrTaskee() => _taskOrTaskee != null;

  // "Data" field.
  DateTime? _data;
  DateTime? get data => _data;
  bool hasData() => _data != null;

  // "Tempo" field.
  DateTime? _tempo;
  DateTime? get tempo => _tempo;
  bool hasTempo() => _tempo != null;

  // "stateEtinia" field.
  String? _stateEtinia;
  String get stateEtinia => _stateEtinia ?? '';
  bool hasStateEtinia() => _stateEtinia != null;

  // "online" field.
  bool? _online;
  bool get online => _online ?? false;
  bool hasOnline() => _online != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _lastActive = snapshotData['lastActive'] as DateTime?;
    _status = snapshotData['status'] as String?;
    _tasksCompleted = getDataList(snapshotData['tasksCompleted']);
    _requestPedidos = getDataList(snapshotData['requestPedidos']);
    _requestEmNumber = castToType<int>(snapshotData['requestEmNumber']);
    _plataform =
        getDataList(snapshotData['plaform'] ?? snapshotData['plataform']);
    _taskOrTaskee = snapshotData['taskOrTaskee'] as String?;
    _data = snapshotData['Data'] as DateTime?;
    _tempo = snapshotData['Tempo'] as DateTime?;
    _stateEtinia = snapshotData['stateEtinia'] as String?;
    _online = snapshotData['online'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  DateTime? lastActive,
  String? status,
  int? requestEmNumber,
  String? taskOrTaskee,
  DateTime? data,
  DateTime? tempo,
  String? stateEtinia,
  bool? online,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'lastActive': lastActive,
      'status': status,
      'requestEmNumber': requestEmNumber,
      'taskOrTaskee': taskOrTaskee,
      'Data': data,
      'Tempo': tempo,
      'stateEtinia': stateEtinia,
      'online': online,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.lastActive == e2?.lastActive &&
        e1?.status == e2?.status &&
        listEquality.equals(e1?.tasksCompleted, e2?.tasksCompleted) &&
        listEquality.equals(e1?.requestPedidos, e2?.requestPedidos) &&
        e1?.requestEmNumber == e2?.requestEmNumber &&
        listEquality.equals(e1?.plataform, e2?.plataform) &&
        e1?.taskOrTaskee == e2?.taskOrTaskee &&
        e1?.data == e2?.data &&
        e1?.tempo == e2?.tempo &&
        e1?.stateEtinia == e2?.stateEtinia &&
        e1?.online == e2?.online;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.lastActive,
        e?.status,
        e?.tasksCompleted,
        e?.requestPedidos,
        e?.requestEmNumber,
        e?.plataform,
        e?.taskOrTaskee,
        e?.data,
        e?.tempo,
        e?.stateEtinia,
        e?.online
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
