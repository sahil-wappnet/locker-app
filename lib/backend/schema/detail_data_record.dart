import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';

class DetailDataRecord extends FirestoreRecord {
  DetailDataRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  bool hasUserId() => _userId != null;

  String? _displayTitle;
  String get displayTitle => _displayTitle ?? '';
  bool hasDisplayTitle() => _displayTitle != null;

  // "data_title" field.
  String? _dataTitle;
  String get dataTitle => _dataTitle ?? '';
  bool hasDataTitle() => _dataTitle != null;

  // "data_description" field.
  String? _dataDescription;
  String get dataDescription => _dataDescription ?? '';
  bool hasDataDescription() => _dataDescription != null;

  void _initializeFields() {
    _userId = snapshotData['user_id'] as String?;
    _displayTitle =snapshotData['display_title'] as String?;
    _dataTitle = snapshotData['data_title'] as String?;
    _dataDescription = snapshotData['data_description'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('detail_data');

  static Stream<DetailDataRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DetailDataRecord.fromSnapshot(s));

  static Future<DetailDataRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DetailDataRecord.fromSnapshot(s));

  static DetailDataRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DetailDataRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DetailDataRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DetailDataRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DetailDataRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DetailDataRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDetailDataRecordData({
  String? userId,
  String? displayTitle,
  String? dataTitle,
  String? dataDescription,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_id': userId,
      'display_title': displayTitle,
      'data_title': dataTitle,
      'data_description': dataDescription,
    }.withoutNulls,
  );

  return firestoreData;
}

class DetailDataRecordDocumentEquality implements Equality<DetailDataRecord> {
  const DetailDataRecordDocumentEquality();

  @override
  bool equals(DetailDataRecord? e1, DetailDataRecord? e2) {
    return e1?.userId == e2?.userId &&
        e1?.dataTitle == e2?.dataTitle &&
        e1?.dataDescription == e2?.dataDescription;
  }

  @override
  int hash(DetailDataRecord? e) =>
      const ListEquality().hash([e?.userId, e?.dataTitle, e?.dataDescription]);

  @override
  bool isValidKey(Object? o) => o is DetailDataRecord;
}
