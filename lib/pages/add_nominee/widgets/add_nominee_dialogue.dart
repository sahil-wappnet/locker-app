import 'dart:convert';
import 'dart:developer';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:locker_app/flutter_flow/flutter_flow_util.dart';
import 'package:pointycastle/export.dart' as expostdata;
import 'package:pointycastle/impl.dart';

import '../../../auth/firebase_auth/auth_util.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';

class AddNomineePageDialog extends StatefulWidget {
  AddNomineePageDialog(
      {this.param, this.confirmBtnText, this.btnClickOperation});

  String? confirmBtnText;
  int? btnClickOperation;
  String? param;

  @override
  _AddNomineePageDialogState createState() => _AddNomineePageDialogState();
}

class _AddNomineePageDialogState extends State<AddNomineePageDialog> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final emailAddressFieldController = TextEditingController();
  String? encryptionKey;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Nominee'),
      content: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            TextFormField(
              controller: emailAddressFieldController,
              decoration: InputDecoration(
                labelText: "Nominee's email",
                labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Roboto Slab',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16.0,
                      lineHeight: 1.5,
                    ),
                hintText: 'Email of Nominee',
                hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Roboto Slab',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 16.0,
                      lineHeight: 1.5,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFD0D5DD),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFF0000),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFF0000),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding:
                    EdgeInsetsDirectional.fromSTEB(14.0, 10.0, 14.0, 10.0),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Roboto Slab',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16.0,
                    lineHeight: 1.5,
                  ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email is required";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFFF0000)),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Close',
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      color: Color(0xFFFF0000),
                    ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              if (formKey.currentState!.validate()) {
                String text = emailAddressFieldController.text;
                context.pop();
                fetchUserEncryptionKey(text);
                // await fetchNomineePublicKey(text);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xFFFC951C),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.confirmBtnText!,
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void fetchUserEncryptionKey(String text) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUserEmail)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        encryptionKey = userData['encryption key'];
        fetchNomineePublicKey(text);
      } else {
        log('User not found');
      }
    } catch (e) {
      log('Error fetching user data: $e');
    }
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // encryptionKey = sharedPreferences.getString('usersEncreptionKey');
  }

  Future<void> fetchNomineePublicKey(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final nomineeEmail = userData['email'];

        final nomineeEncrptionString = encryptionKey;

        // String plaintext = widget.param!;
        // final rsaPublicKey =
        //     RSAKeyParser().parse(nomineePublicKeyString) as RSAPublicKey;
        // final encrypter = RSAEngine()
        //   ..init(
        //       true, expostdata.PublicKeyParameter<RSAPublicKey>(rsaPublicKey));

        // final plaintextBytes = Uint8List.fromList(utf8.encode(plaintext));
        // final encryptedBytes = encrypter.process(plaintextBytes);

        // final encryptedText = base64.encode(encryptedBytes);

        // final parser = RSAKeyParser();
        // final publicKey = parser.parse(nomineePublicKeyString) as RSAPublicKey;
        // final encrypter = Encrypter(RSA(publicKey: publicKey));
        // final encryptedData = encrypter.encrypt(widget.param!);

        // final encryptedText = hex.encode(encryptedData.bytes);

        // log("Encryption key is before sending : ${widget.param}");
        // log('Public key : $nomineePublicKeyString');
        // log('before encryptedData : ${widget.param!}');
        // log('after DecryptionData : $encryptedText');

        final sharedWithMeCollection =
            FirebaseFirestore.instance.collection('shared_with_me');
        await sharedWithMeCollection.add({
          'nominee email': nomineeEmail,
          'users email': currentUserEmail,
          'shared encryption key': nomineeEncrptionString
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Nominee added successfully',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
        emailAddressFieldController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User not found!',
            ),
          ),
        );
        log('User not found');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error fetching user data: $e',
          ),
        ),
      );
      log('Error fetching user data: $e');
    }
  }

  String decryptData(
      String encryptedData, expostdata.RSAPrivateKey privateKey) {
    final cipher = expostdata.RSAEngine()
      ..init(
        false,
        expostdata.PrivateKeyParameter<expostdata.RSAPrivateKey>(privateKey),
      );

    final cipherText = base64Decode(encryptedData);
    final decryptedBytes = cipher.process(cipherText);
    log("${String.fromCharCodes(decryptedBytes)}");
    return String.fromCharCodes(decryptedBytes);
  }

  String encryptData(String data, expostdata.RSAPublicKey publicKey) {
    final cipher = expostdata.RSAEngine()
      ..init(
        true, // true for encryption
        expostdata.PublicKeyParameter<expostdata.RSAPublicKey>(publicKey),
      );

    final Uint8List plainText = Uint8List.fromList(data.codeUnits);
    final cipherText = cipher.process(plainText);
    return base64Encode(cipherText);
  }

  RSAPrivateKey parsePrivateKey(String privateKeyPEM) {
    final rsaParser = RSAKeyParser();
    final privateKey = rsaParser.parse(privateKeyPEM) as RSAPrivateKey;
    return privateKey;
  }

  RSAPublicKey parsePublicKey(String publicKeyPEM) {
    final rsaParser = RSAKeyParser();
    final publicKey = rsaParser.parse(publicKeyPEM) as RSAPublicKey;
    return publicKey;
  }
}
