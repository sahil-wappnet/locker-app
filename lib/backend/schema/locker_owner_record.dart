import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LockerOwnerRecord extends FirestoreRecord {
  LockerOwnerRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "private_key" field.
  String? _privateKey;
  String get privateKey => _privateKey ?? '';
  bool hasPrivateKey() => _privateKey != null;

  // "public_key" field.
  String? _publicKey;
  String get publicKey => _publicKey ?? '';
  bool hasPublicKey() => _publicKey != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _privateKey = snapshotData['private_key'] as String?;
    _publicKey = snapshotData['public_key'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('locker_owner');

  static Stream<LockerOwnerRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LockerOwnerRecord.fromSnapshot(s));

  static Future<LockerOwnerRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => LockerOwnerRecord.fromSnapshot(s));

  static LockerOwnerRecord fromSnapshot(DocumentSnapshot snapshot) =>
      LockerOwnerRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LockerOwnerRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LockerOwnerRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LockerOwnerRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LockerOwnerRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLockerOwnerRecordData({
  String? email,
  String? privateKey,
  String? publicKey,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'private_key': privateKey,
      'public_key': publicKey,
    }.withoutNulls,
  );

  return firestoreData;
}

class LockerOwnerRecordDocumentEquality implements Equality<LockerOwnerRecord> {
  const LockerOwnerRecordDocumentEquality();

  @override
  bool equals(LockerOwnerRecord? e1, LockerOwnerRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.privateKey == e2?.privateKey &&
        e1?.publicKey == e2?.publicKey;
  }

  @override
  int hash(LockerOwnerRecord? e) =>
      const ListEquality().hash([e?.email, e?.privateKey, e?.publicKey]);

  @override
  bool isValidKey(Object? o) => o is LockerOwnerRecord;
}
