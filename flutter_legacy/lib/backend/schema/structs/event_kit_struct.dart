// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class EventKitStruct extends FFFirebaseStruct {
  EventKitStruct({
    String? description,
    double? price,
    String? fotos,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _description = description,
        _price = price,
        _fotos = fotos,
        super(firestoreUtilData);

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "fotos" field.
  String? _fotos;
  String get fotos => _fotos ?? '';
  set fotos(String? val) => _fotos = val;

  bool hasFotos() => _fotos != null;

  static EventKitStruct fromMap(Map<String, dynamic> data) => EventKitStruct(
        description: data['description'] as String?,
        price: castToType<double>(data['price']),
        fotos: data['fotos'] as String?,
      );

  static EventKitStruct? maybeFromMap(dynamic data) =>
      data is Map ? EventKitStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'description': _description,
        'price': _price,
        'fotos': _fotos,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'fotos': serializeParam(
          _fotos,
          ParamType.String,
        ),
      }.withoutNulls;

  static EventKitStruct fromSerializableMap(Map<String, dynamic> data) =>
      EventKitStruct(
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        fotos: deserializeParam(
          data['fotos'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'EventKitStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EventKitStruct &&
        description == other.description &&
        price == other.price &&
        fotos == other.fotos;
  }

  @override
  int get hashCode => const ListEquality().hash([description, price, fotos]);
}

EventKitStruct createEventKitStruct({
  String? description,
  double? price,
  String? fotos,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EventKitStruct(
      description: description,
      price: price,
      fotos: fotos,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EventKitStruct? updateEventKitStruct(
  EventKitStruct? eventKit, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    eventKit
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEventKitStructData(
  Map<String, dynamic> firestoreData,
  EventKitStruct? eventKit,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (eventKit == null) {
    return;
  }
  if (eventKit.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && eventKit.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final eventKitData = getEventKitFirestoreData(eventKit, forFieldValue);
  final nestedData = eventKitData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = eventKit.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEventKitFirestoreData(
  EventKitStruct? eventKit, [
  bool forFieldValue = false,
]) {
  if (eventKit == null) {
    return {};
  }
  final firestoreData = mapToFirestore(eventKit.toMap());

  // Add any Firestore field values
  eventKit.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEventKitListFirestoreData(
  List<EventKitStruct>? eventKits,
) =>
    eventKits?.map((e) => getEventKitFirestoreData(e, true)).toList() ?? [];
