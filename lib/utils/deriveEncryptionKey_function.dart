import 'dart:convert';
import 'package:pointycastle/export.dart';

import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart' as pointycastle;
import 'package:pointycastle/key_derivators/api.dart' as keyDerivators;

class ConstanData{
  static String encryptionKey="";
  static String userId="";
}

Future<Uint8List> deriveEncryptionKey(String masterPassword, String userId, String email) async {
  // Convert the user-provided data to bytes
  Uint8List masterPasswordBytes = Uint8List.fromList(utf8.encode(masterPassword));
  Uint8List userIdBytes = Uint8List.fromList(utf8.encode(userId));
  Uint8List emailBytes = Uint8List.fromList(utf8.encode(email));

  // Concatenate the bytes of masterPassword, userId, and email
  Uint8List combinedBytes = Uint8List.fromList([...masterPasswordBytes, ...userIdBytes, ...emailBytes]);

  // Create a salt (a random value to make the derivation more secure)
  final salt = Uint8List(16); // 16 bytes (128 bits) salt

  // Set the number of iterations (higher values are more secure but slower)
  final iterations = 10000;

  // Set the desired key length (in bytes)
  final keyLength = 16; 
  // Use PBKDF2 to derive the key
  final keyDerivator = PBKDF2KeyDerivator(
    HMac(pointycastle.Digest("SHA-256"), 64),
  )
    ..init(keyDerivators.Pbkdf2Parameters(
      salt, 
      iterations,
      keyLength,
    ));
  final keyBytes = keyDerivator.process(combinedBytes);
  
  return Uint8List.fromList(keyBytes);
}

int bytesToInt(Uint8List bytes) {
  int result = 0;
  for (int i = 0; i < bytes.length; i++) {
    result += bytes[i] << (8 * i);
  }
  return result;
}


 String encryptData(String text, String key) {
  final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return base64Encode(encrypted.bytes);
  }

   String decryptData(String encryptedText, String key) {
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
    final encryptedBytes = base64Decode(encryptedText);
    final decrypted = encrypter.decrypt(Encrypted(encryptedBytes), iv: iv);
    return decrypted;
  }

  String encryptOperation(String text, String key) {
    final keyBytes = Uint8List.fromList(utf8.encode(key));
    final encryptedBytes = _encryptBytes(text, keyBytes);
    final encryptedString = base64Encode(encryptedBytes);
    return encryptedString;
  }

  String decryptOperation(String encryptedText, String key) {
    final keyBytes = Uint8List.fromList(utf8.encode(key));
    final encryptedBytes = base64Decode(encryptedText);
    final decryptedString = _decryptBytes(encryptedBytes, keyBytes);
    return decryptedString;
  }

  Uint8List _encryptBytes(String text, Uint8List keyBytes) {
    final cipher = AESFastEngine();
    final cbcCipher = CBCBlockCipher(cipher);
    final params = ParametersWithIV(KeyParameter(keyBytes), Uint8List(16));

    cbcCipher.init(true, params);

    final textBytes = Uint8List.fromList(utf8.encode(text));
    final paddedText = _padText(textBytes);

    final encryptedBytes = Uint8List(paddedText.length);

    var offset = 0;

    while (offset < paddedText.length) {
      offset += cbcCipher.processBlock(
          paddedText, offset, encryptedBytes, offset);
    }

    return encryptedBytes;
  }

  String _decryptBytes(Uint8List encryptedBytes, Uint8List keyBytes) {
    final cipher = AESFastEngine();
    final cbcCipher = CBCBlockCipher(cipher);
    final params = ParametersWithIV(KeyParameter(keyBytes), Uint8List(16));

    cbcCipher.init(false, params);

    final decryptedBytes = Uint8List(encryptedBytes.length);

    var offset = 0;

    while (offset < encryptedBytes.length) {
      offset += cbcCipher.processBlock(
          encryptedBytes, offset, decryptedBytes, offset);
    }

    final unpadText = _unpadText(decryptedBytes);

    return utf8.decode(unpadText);
  }

  Uint8List _padText(Uint8List textBytes) {
    final blockSize = 16;
    final padLength = blockSize - (textBytes.length % blockSize);
    final paddedText = Uint8List(textBytes.length + padLength);

    paddedText.setAll(0, textBytes);
    for (var i = textBytes.length; i < paddedText.length; i++) {
      paddedText[i] = padLength;
    }

    return paddedText;
  }

  Uint8List _unpadText(Uint8List textBytes) {
    final padLength = textBytes[textBytes.length - 1];
    return Uint8List.sublistView(textBytes, 0, textBytes.length - padLength);
  }

String bytesToHexString(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
}
