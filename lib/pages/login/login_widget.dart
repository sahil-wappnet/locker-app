import 'dart:developer';
import 'package:pointycastle/export.dart' as exportpointycastle;
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import '../../utils/deriveEncryptionKey_function.dart';
import '../../utils/functions.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart'
    as platform;
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    _model.emailAddressFieldController ??= TextEditingController();
    _model.passwordFieldController ??= TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.00, 0.00),
            child: Container(
              width: 360.0,
              decoration: BoxDecoration(),
              child: Align(
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.asset(
                                'assets/images/locker_appicon.png',
                              ).image,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8.0,
                                color: Color(0x1917171C),
                                offset: Offset(0.0, 4.0),
                                spreadRadius: 0.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    SelectionArea(
                        child: Text(
                      'Log in to your account',
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Outfit',
                                fontSize: 30.0,
                                fontWeight: FontWeight.w600,
                                lineHeight: 1.2,
                              ),
                    )),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: SelectionArea(
                          child: Text(
                        'Welcome back! Please enter your details.',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Roboto Slab',
                              lineHeight: 1.5,
                            ),
                      )),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                      child: Form(
                        key: _model.formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 6.0, 0.0, 0.0),
                              child: TextFormField(
                                controller: _model.emailAddressFieldController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Roboto Slab',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 16.0,
                                        lineHeight: 1.5,
                                      ),
                                  hintText: 'Enter your email',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Roboto Slab',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
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
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                      EdgeInsetsDirectional.fromSTEB(
                                          14.0, 10.0, 14.0, 10.0),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Roboto Slab',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 16.0,
                                      lineHeight: 1.5,
                                    ),
                                keyboardType: TextInputType.emailAddress,
                                validator: _model
                                    .emailAddressFieldControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 0.0),
                              child: TextFormField(
                                controller: _model.passwordFieldController,
                                obscureText: !_model.passwordFieldVisibility,
                                decoration: InputDecoration(
                                  labelText: 'Master Password',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Roboto Slab',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 16.0,
                                        lineHeight: 1.5,
                                      ),
                                  hintText: 'Enter Master Password',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Roboto Slab',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
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
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                      EdgeInsetsDirectional.fromSTEB(
                                          14.0, 10.0, 14.0, 10.0),
                                  suffixIcon: InkWell(
                                    onTap: () => setState(
                                      () => _model.passwordFieldVisibility =
                                          !_model.passwordFieldVisibility,
                                    ),
                                    focusNode: FocusNode(skipTraversal: true),
                                    child: Icon(
                                      _model.passwordFieldVisibility
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Roboto Slab',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 16.0,
                                      lineHeight: 1.5,
                                    ),
                                validator: _model
                                    .passwordFieldControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (_model.formKey.currentState!.validate()) {
                            GoRouter.of(context).prepareAuthEvent();

                            final user = await authManager.signInWithEmail(
                              context,
                              _model.emailAddressFieldController.text,
                              _model.passwordFieldController.text,
                            );
                            if (user == null) {
                              return;
                            }

                            final encryptionKey = await deriveEncryptionKey(
                                '${_model.passwordFieldController.text}',
                                '${user.uid!}',
                                '${_model.emailAddressFieldController.text}');

                            final userDocRef = FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid);

                            final userDocSnapshot = await userDocRef.get();
                            final publicKeyExists = userDocSnapshot.exists &&
                                userDocSnapshot.data() != null &&
                                userDocSnapshot
                                    .data()!
                                    .containsKey('encryptionKey');

                            if (!publicKeyExists) {
                              final userDocRef = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid!);
                              await userDocRef.update({
                                'encryptionKey':
                                    bytesToHexString(encryptionKey),
                              });
                            }

                            final rsaKeyExists = userDocSnapshot.exists &&
                                userDocSnapshot.data() != null &&
                                userDocSnapshot
                                    .data()!
                                    .containsKey('public key');

                            if (!rsaKeyExists) {
                              int bitLength = 2048;
                              final keyGen = RSAKeyGenerator();
                              final secureRandom =
                                  exportpointycastle.SecureRandom('Fortuna')
                                    ..seed(exportpointycastle.KeyParameter(
                                        platform.Platform.instance
                                            .platformEntropySource()
                                            .getBytes(32)));

                              keyGen.init(
                                  exportpointycastle.ParametersWithRandom(
                                      exportpointycastle
                                          .RSAKeyGeneratorParameters(
                                              BigInt.parse('65537'),
                                              bitLength,
                                              64),
                                      secureRandom));
                              final pair = keyGen.generateKeyPair();

                              final myPublic = pair.publicKey
                                  as exportpointycastle.RSAPublicKey;
                              final myPrivate = pair.privateKey
                                  as exportpointycastle.RSAPrivateKey;
                              final keyPair =
                                  exportpointycastle.AsymmetricKeyPair<
                                          exportpointycastle.RSAPublicKey,
                                          exportpointycastle.RSAPrivateKey>(
                                      myPublic, myPrivate);
                              final publicKey = keyPair.publicKey;
                              final privateKey = keyPair.privateKey;

                              log('Generated Public Key:');
                              log(encodePublicKeyToPem(publicKey));

                              log('Generated Private Key:');
                              log(encodePrivateKeyToPem(privateKey));

                              final userDocRef = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid!);
                              await userDocRef.update({
                                'public key': encodePublicKeyToPem(publicKey),
                                'private key': encryptOperation(encodePrivateKeyToPem(privateKey), bytesToHexString(encryptionKey))
                                // encryptPrivateKey(
                                //     encodePrivateKeyToPem(privateKey),
                                //     publicKey,
                                //     bytesToHexString(encryptionKey)),
                              });
                            }

                            context.pushNamedAuth(
                                'veryfication_page', context.mounted);
                          }
                        },
                        text: 'Log in',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 44.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Roboto Slab',
                                    color: Colors.white,
                                  ),
                          elevation: 2.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SelectionArea(
                              child: Text(
                            'Don\'t have an account? ',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Roboto Slab',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                          )),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                'sign_in',
                                extra: <String, dynamic>{
                                  kTransitionInfoKey: TransitionInfo(
                                    hasTransition: false,
                                    transitionType:
                                        PageTransitionType.rightToLeft,
                                  ),
                                },
                              );
                              _model.passwordFieldController?.clear();
                              _model.emailAddressFieldController?.clear();
                            },
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Text(
                                'Sign-up',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Roboto Slab',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//   String decryptPrivateKey(
//     String encryptedPrivateKey, RSAPrivateKey privateKey, String encryptionKeyHex) {
//   final rsaDecrypter = RSAEngine()
//     ..init(
//       false,
//       PrivateKeyParameter<RSAPrivateKey>(privateKey),
//     );

//   final cipherText = base64.decode(encryptedPrivateKey);

//   final decryptedEncryptionKey = rsaDecrypter.process(cipherText);
  
//   final decryptedKeyHex = hex.encode(decryptedEncryptionKey);

//   return decryptedKeyHex;
// }

  String encryptPrivateKey(String privateKey,
      exportpointycastle.RSAPublicKey publicKey, String encryptionKeyHex) {
    final rsaEncrypter = exportpointycastle.RSAEngine()
      ..init(
        true,
        exportpointycastle.PublicKeyParameter<exportpointycastle.RSAPublicKey>(
            publicKey),
      );

    final encryptionKey = Uint8List.fromList(hex.decode(encryptionKeyHex));

    final cipherText = rsaEncrypter.process(encryptionKey);

    final encryptedPrivateKey = base64.encode(cipherText);

    return encryptedPrivateKey;
  }
}
