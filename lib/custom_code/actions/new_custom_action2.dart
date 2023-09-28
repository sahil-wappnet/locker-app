// // Automatic FlutterFlow imports
// import '/backend/backend.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import 'index.dart'; // Imports other custom actions
// import 'package:flutter/material.dart';
// // Begin custom action code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import "package:pointycastle/export.dart";
// import 'package:pointycastle/src/platform_check/platform_check.dart'
//     as platform;
// import 'dart:convert';
// import "package:asn1lib/asn1lib.dart";

// Future newCustomAction2(
//   String? email,
//   String? password,
//   String? userId,
// ) async {
//   const fixedValue = '123456789012';
//   final combinedValue = password! + email! + fixedValue + userId!;

//   final pbkdf2 = PBKDF2KeyDerivator(
//     HMac(SHA256Digest(), 64), // Use SHA-256 and 64-byte output
//   );

//   final salt = Uint8List.fromList(utf8.encode(userId)); // Use user ID as salt
//   pbkdf2.init(Pbkdf2Parameters(salt, 10000, 32)); // 32-byte (256-bit) key

//   final key = pbkdf2.process(Uint8List.fromList(utf8.encode(combinedValue)));
//   final encryptionKey = Uint8List.fromList(key);

//   final encryptionKeyHex = encryptionKey
//       .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
//       .join();

//   final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
//   final userDocSnapshot = await userDocRef.get();
//   final publicKeyExists = userDocSnapshot.exists &&
//       userDocSnapshot.data() != null &&
//       userDocSnapshot.data()!.containsKey('publicKey');

//   if (!publicKeyExists) {
//     final secureRandom = SecureRandom('Fortuna')
//       ..seed(KeyParameter(
//           platform.Platform.instance.platformEntropySource().getBytes(32)));

//     final keyGen = RSAKeyGenerator();

//     keyGen.init(ParametersWithRandom(
//         RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
//         secureRandom));

//     final pair = keyGen.generateKeyPair();

//     final myPublic = pair.publicKey as RSAPublicKey;
//     final myPrivate = pair.privateKey as RSAPrivateKey;

//     final keyPair =
//         AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);

//     final publicKey = keyPair.publicKey;
//     final privateKey = keyPair.privateKey;

//     var algorithmSeq = ASN1Sequence();
//     var algorithmAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList(
//         [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
//     var paramsAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
//     algorithmSeq.add(algorithmAsn1Obj);
//     algorithmSeq.add(paramsAsn1Obj);

//     var publicKeySeq = ASN1Sequence();
//     publicKeySeq.add(ASN1Integer(publicKey.modulus!));
//     publicKeySeq.add(ASN1Integer(publicKey.exponent!));
//     var publicKeySeqBitString =
//         ASN1BitString(Uint8List.fromList(publicKeySeq.encodedBytes));

//     var topLevelSeq = ASN1Sequence();
//     topLevelSeq.add(algorithmSeq);
//     topLevelSeq.add(publicKeySeqBitString);
//     var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

//     final dynamic encodePublicKeyToPem =
//         """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";

//     var version = ASN1Integer(BigInt.from(0));

//     var algorithmSeq2 = ASN1Sequence();
//     var algorithmAsn1Obj2 = ASN1Object.fromBytes(Uint8List.fromList(
//         [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
//     var paramsAsn1Obj2 = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
//     algorithmSeq2.add(algorithmAsn1Obj2);
//     algorithmSeq2.add(paramsAsn1Obj2);

//     var privateKeySeq = ASN1Sequence();
//     var modulus = ASN1Integer(privateKey.n!);
//     var publicExponent = ASN1Integer(BigInt.parse('65537'));
//     var privateExponent = ASN1Integer(privateKey.d!);
//     var p = ASN1Integer(privateKey.p!);
//     var q = ASN1Integer(privateKey.q!);
//     var dP = privateKey.d! % (privateKey.p! - BigInt.from(1));
//     var exp1 = ASN1Integer(dP);
//     var dQ = privateKey.d! % (privateKey.q! - BigInt.from(1));
//     var exp2 = ASN1Integer(dQ);
//     var iQ = privateKey.q!.modInverse(privateKey.p!);
//     var co = ASN1Integer(iQ);

//     privateKeySeq.add(version);
//     privateKeySeq.add(modulus);
//     privateKeySeq.add(publicExponent);
//     privateKeySeq.add(privateExponent);
//     privateKeySeq.add(p);
//     privateKeySeq.add(q);
//     privateKeySeq.add(exp1);
//     privateKeySeq.add(exp2);
//     privateKeySeq.add(co);
//     var publicKeySeqOctetString =
//         ASN1OctetString(Uint8List.fromList(privateKeySeq.encodedBytes));

//     var topLevelSeq2 = ASN1Sequence();
//     topLevelSeq2.add(version);
//     topLevelSeq2.add(algorithmSeq2);
//     topLevelSeq2.add(publicKeySeqOctetString);
//     var dataBase64Private = base64.encode(topLevelSeq2.encodedBytes);
//     final dynamic encodePrivateKeyToPem =
//         """-----BEGIN PRIVATE KEY-----\r\n$dataBase64Private\r\n-----END PRIVATE KEY-----""";

//     final userDocRef =
//         FirebaseFirestore.instance.collection('users').doc(userId);
//     await userDocRef.update({
//       'privateKey': encodePublicKeyToPem,
//       'publicKey': encodePrivateKeyToPem,
//     });
//   }
// }
