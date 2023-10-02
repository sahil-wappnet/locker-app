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
                // You can add more validation rules here if needed.
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
                log("message $text");
                await fetchNomineePublicKey(text);
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

  Future<void> fetchNomineePublicKey(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
                final nomineeEmail = userData['email'];

        final nomineePublicKeyString = userData['public key'];
        
        final nomineePublicKey = parsePublicKey(nomineePublicKeyString);
                
        final encryptedData = encryptData(widget.param!, nomineePublicKey);
        log("Encryption key is before sending : ${widget.param}");
        log('Public key : $nomineePublicKeyString');       
        log('encryptedData : $encryptedData');
        
        final sharedWithMeCollection = FirebaseFirestore.instance.collection('shared_with_me');
        await sharedWithMeCollection.add({
          'nominee email': nomineeEmail,
          'users email': currentUserEmail,
          'shared encryption key': encryptedData

        });
        
        context.pop();
        emailAddressFieldController.clear();
      } else {
        log('User not found');
      }
    } catch (e) {
      log('Error fetching user data: $e');
    }
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

  String decryptData(
      String encryptedData, expostdata.RSAPrivateKey privateKey) {
    final cipher = expostdata.RSAEngine()
      ..init(
        false, // false for decryption
        expostdata.PrivateKeyParameter<expostdata.RSAPrivateKey>(privateKey),
      );

    final cipherText = base64Decode(encryptedData);
    final decryptedBytes = cipher.process(cipherText);
    return String.fromCharCodes(decryptedBytes);
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
