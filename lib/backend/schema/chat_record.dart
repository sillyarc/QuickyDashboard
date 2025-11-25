import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChatRecord extends FirestoreRecord {
  ChatRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "referenceTask" field.
  DocumentReference? _referenceTask;
  DocumentReference? get referenceTask => _referenceTask;
  bool hasReferenceTask() => _referenceTask != null;

  // "user2Document" field.
  DocumentReference? _user2Document;
  DocumentReference? get user2Document => _user2Document;
  bool hasUser2Document() => _user2Document != null;

  // "userDocument" field.
  DocumentReference? _userDocument;
  DocumentReference? get userDocument => _userDocument;
  bool hasUserDocument() => _userDocument != null;

  // "ultimaMsg" field.
  DateTime? _ultimaMsg;
  DateTime? get ultimaMsg => _ultimaMsg;
  bool hasUltimaMsg() => _ultimaMsg != null;

  // "rideSOS" field.
  bool? _rideSOS;
  bool get rideSOS => _rideSOS ?? false;
  bool hasRideSOS() => _rideSOS != null;

  void _initializeFields() {
    _referenceTask = snapshotData['referenceTask'] as DocumentReference?;
    _user2Document = snapshotData['user2Document'] as DocumentReference?;
    _userDocument = snapshotData['userDocument'] as DocumentReference?;
    _ultimaMsg = snapshotData['ultimaMsg'] as DateTime?;
    _rideSOS = snapshotData['rideSOS'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('chat');

  static Stream<ChatRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatRecord.fromSnapshot(s));

  static Future<ChatRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatRecord.fromSnapshot(s));

  static ChatRecord fromSnapshot(DocumentSnapshot snapshot) => ChatRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatRecordData({
  DocumentReference? referenceTask,
  DocumentReference? user2Document,
  DocumentReference? userDocument,
  DateTime? ultimaMsg,
  bool? rideSOS,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'referenceTask': referenceTask,
      'user2Document': user2Document,
      'userDocument': userDocument,
      'ultimaMsg': ultimaMsg,
      'rideSOS': rideSOS,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatRecordDocumentEquality implements Equality<ChatRecord> {
  const ChatRecordDocumentEquality();

  @override
  bool equals(ChatRecord? e1, ChatRecord? e2) {
    return e1?.referenceTask == e2?.referenceTask &&
        e1?.user2Document == e2?.user2Document &&
        e1?.userDocument == e2?.userDocument &&
        e1?.ultimaMsg == e2?.ultimaMsg &&
        e1?.rideSOS == e2?.rideSOS;
  }

  @override
  int hash(ChatRecord? e) => const ListEquality().hash(
      [e?.referenceTask, e?.user2Document, e?.userDocument, e?.ultimaMsg, e?.rideSOS]);

  @override
  bool isValidKey(Object? o) => o is ChatRecord;
}
